## VERDIKT: ENTSCHIEDEN

Die im Auftrag als „vermeintlich offen" bezeichnete Owner-Wahl (a) vs. (b) ist **entschieden — und zwar nicht dahin, dass „behalten+ausweisen" alles abdeckt, sondern in die Gegenrichtung: der Owner hat (b) direkt angeordnet.** Die P78-Ruling „behalten" von 05.08. ist damit am 16.08. explizit **überschrieben**, nicht bloß re-bestätigt.

## Die Kette (vier Belege, chronologisch)

**1) Ur-Entscheid P78 „behalten" (05.08.2026, abend-10).**
Frage im Vorlage-Dokument `docs/sessions/20260805-OWNER-VORLAGE-v5-entscheide-und-kenntnis.md:79-109` (Abschnitt „A3 · Posten 78"): Optionen waren dort (A) sofort heilen via Offline-Peeling — explizit als „echte Bau-Scheibe in der knappsten Phase" benannt — vs. (B) behalten+deklarieren, Heilung als **Nach-Abgabe-Posten**. Empfehlung+Default: (B), außer der Owner stuft den Membership-Vertrag aller vier Filter als Kern ein.
Owner-Antwort wörtlich, `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:25546` (NACHTRAG 05.08.2026 abend-10): **„(A3) Wie empfohlen. Aber bitte die Einschränkung dokumentieren."** — Wahl von (B)=behalten, Heilung vertagt. Am Objekt verankert in `Code/external/comdare-cache-engine/libs/cache_engine/organ_axes/filter_axis/axis_filter_xor.hpp:55-68` als Kommentarblock „POSTEN 78 / OWNER-ENTSCHEID A3", Commit `442c960b`/`c837d830`.

**2) W-F-Urteil reproduziert den Defekt und legt die Frage neu vor (15.08.2026).**
`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1619-1631` (KON74-05, Strang W-F, „read-only Analyse Fable max" laut Strangkarte `:1749`): Defekt bit-exakt reproduziert, Reichweite = XorFilter-Zelle bestätigt, aber die Frage „(a) A3 re-bestätigen ODER (b) Umbau Offline-Peeling" wird als **vor der nächsten Messreihe zu klärender** Punkt formuliert. Task-Neuanlage #70 dazu bereits vorher in KON72-05, `:1926`. Als Ein-Satz-Vorlage formalisiert in `docs/sessions/20260815-OWNER-VORLAGEN-V1-V7-nachstufen-tag.md:9-16` (Abschnitt „V1").

**3) Owner-Antwort, wörtlich (16.08.2026).**
Rohtranskript `docs/sessions/backups/20260816-folge-bu-kontext8/kon64_sammlung.md:1337-1338` (TEIL 32, „OWNER-ANTWORTRUNDE V1-V10, VERBATIM-KERNE"):
**„V1: 'Bitte direkt (b) bauen, wir machen es gleich richtig, sonst haben wir doppelt arbeit.' [= XorFilter Offline-Peeling-Umbau Graf/Lemire]"**
Ledger-Konsolidierung `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1217-1225` (KON80-01, 16.08.2026): **„V1 XORFILTER = DIREKT (b): Offline-Peeling-Umbau Graf/Lemire ('wir machen es gleich richtig, sonst haben wir doppelt arbeit') -> deklariertes golden-Ereignis Filter-Zelle, #70 wird BAU-Posten W1."**

**4) Gegenprobe „nichts Neueres widerspricht".**
Alle Ledger-Zeilen zwischen KON80 (16.08., Zeile 1217) und dem aktuellen Kopf KON104 (17.08., Zeile ~11) auf „XorFilter"/„Peeling"/„#70" durchsucht (case-insensitive) — 0 weitere Treffer. Die frische 10-Wochen-Explore-Restfragenliste von heute (`docs/sessions/20260817-OWNER-VORAB-15-restfragen.md`) enthält 0 Treffer zu XorFilter/#70/Peeling — der Posten ist dort nicht mehr als offene Owner-Frage gelistet.

## Fallen-Hinweis (Kürzel zerlegt, nicht verlassen)

Die Buchstaben (a)/(b) sind zwischen 05.08. und 15./16.08. **vertauscht**: am 05.08. war (A)=heilen/(B)=behalten (Owner wählte B); am 15./16.08. war (a)=Ruling-re-bestätigen/(b)=Umbau (Owner wählte b). Beide Male ist der GEGENSTAND, nicht der Buchstabe, geprüft worden — „(b)" am 16.08. ist durch die Klammer-Annotation im Rohtranskript UND durch die Ledger-Paraphrase explizit als „Offline-Peeling-Umbau Graf/Lemire" benannt, keine Kürzel-Fehldeutung möglich.

## GEPINNT-Zeile neg==0 + ihre Doku

`Code/external/comdare-cache-engine/tests/unit/test_s5_02b_filter_perf_sanity.cpp:253-276`: gründlich dokumentiert — erklärt die Semantik (jede Query ist ein gespeicherter Key, „neg" ist zwangsläufig ein False Negative), erklärt warum es vorbestehend/nicht aus diesem Test-Slice stammt, und trägt zwei Assertions: die Kompositions-Wache (`:274`, verlangt `neg==0` NUR für Bloom/Cuckoo/RangeSurf, XorFilter bewusst ausgenommen) und die separat gepinnte Beleg-Zeile (`:275`, `xorf.axis_stats[kAxisFilter][2] > 0` — hält den Defekt sichtbar rot). Beide Fundstellen (Header UND Test) tragen wortgleich die Anweisung: „Fällt diese Zeile [wird neg==0], ist der Befund geheilt und der Kommentar oben ist nachzuziehen."

## Was daraus für den Bau folgt

- **Kein Entscheidungs-Bau mehr nötig** — die Wahl ist getroffen. Option (a) „nur FN-Ausweisung operationalisieren, Konstruktion behalten" ist **nicht** der Weg; das war die Hypothese der Frage, sie trifft nicht zu.
- **Bau-Posten:** echte Offline-Peeling-Konstruktion (Graf/Lemire) für XorFilter, aus dem VOLLEN Key-Satz gebaut (analog zum bestehenden `build_from_sorted_keys`-Muster), ersetzt die heutige inkrementelle `insert_key()`-Konstruktion in `axis_filter_xor.hpp`. Als „deklariertes golden-Ereignis" markiert — läuft also durch dieselbe golden-Fenster-Prozedur wie andere fingerprint-bewegende Brüche (Präzedenz B2/KON74-01).
- **Ziel-Wirkung:** löst die gepinnte Zeile `:275` kontrolliert auf 0 aus; danach ist der OWNER-AUFLAGE-Kommentarblock in `axis_filter_xor.hpp` (und die daran hängende Doku-Pflicht für Thesis/Messbild) nachzuziehen/zu entfernen, weil ihre Grundlage (der Defekt) entfällt.
- **Stand heute (17.08., live geprüft):** NOCH NICHT GEBAUT. `git log --all` im ce-Checkout zeigt keinen Peeling/Graf-Lemire-Commit; `axis_filter_xor.hpp` führt weiterhin die alte vereinfachte Konstruktion samt 05.08.-Kommentar. Bestätigt auch durch den heute (17.08. 09:38) aktualisierten Wellenplan `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:2213`: „#70 | XorFilter-Korrektheit (30/256 FN) VOR nächster Messung | (P-nah) | W1" — weiterhin als geplanter, nicht vollzogener Welle-1-Bauposten geführt. Die verengte Rest-Frage ist rein die AUSFÜHRUNG (Wann in W1 landet der Umbau, vor welcher Messreihe), keine Entscheidungsfrage mehr.

## GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (gezielte Volltextsuche über alle 30597 Zeilen nach P78/XorFilter/#70/Graf/Lemire/Peeling/GEPINNT/neg==0, plus Lesen aller Fundkontexte KON-17, KON72-05, KON74-05, KON80-01, KON96-KON104-Kopfzeilen); `docs/sessions/20260805-OWNER-VORLAGE-v5-entscheide-und-kenntnis.md` (A3-Abschnitt volltext); `docs/sessions/20260815-OWNER-VORLAGEN-V1-V7-nachstufen-tag.md` (V1-Abschnitt volltext); `docs/sessions/backups/20260816-folge-bu-kontext8/kon64_sammlung.md` (Rohtranskript, Teile 30-37 volltext, XorFilter-Grep über die ganze Datei); `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md` (Negativkontrolle); `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` (Zeile 2213); Code am Objekt: `axis_filter_xor.hpp`, `test_s5_02b_filter_perf_sanity.cpp` (READ-ONLY unter `Code/external/comdare-cache-engine @ development`, HEAD `04ac26fa`, 2026-08-17); `git log --all` auf Peeling/Graf/Lemire/XorFilter-Commits.

**NICHT GEPRÜFT:** die vollständigen Thesis-Kapitel auf Messwert-Stellen mit XorFilter-pos/neg-Zahlen (nur eine architektonische Erwähnung in `03_messsystem_prtart.tex:312` gegengelesen, keine Verletzung der Ausweisungspflicht gefunden — aber keine Volltextsuche über alle Thesis-Anhänge); die vollständige Rohtranskript-Datei `docs/sessions/backups/20260815-folge-bu-kontext7/dumps/kon64_sammlung.md` (0 Treffer bei gezieltem Grep, aber nicht Zeile für Zeile gelesen); die 5 fach-repo-lokalen Ledger-Sections (ce/prt-art/thesis `docs/ledger-sections/*.md`) laut Audit-Klausel — nur das super-Ledger wurde durchsucht.