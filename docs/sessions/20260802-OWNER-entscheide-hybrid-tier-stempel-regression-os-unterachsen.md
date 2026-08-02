# OWNER-ENTSCHEIDE 02.08.2026 (~11:0x CEST) — Hybrid-Tier-Definition · Stempel-REGRESSION · OS-Unter-Achsen PFLICHT · Paket-Erweiterungen

> Antworten auf die 9 Fragen aus docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md §H. **Owner-KERN = Gesetz; Wortlaut unten VERBATIM gesichert** (Chunk-Delta-Lehre: Owner-Antworten sofort wörtlich persistieren).

## Owner-Wortlaut (verbatim)

„Entscheid 1 - Das ist kein Konflikt, weil die Hybrid-Tier Binaries bei exakter Designplanung durch Fable 5 xhigh und ultracode klar als eine weitere Stufe hinter der CEB definiert sind. Sie haben mehrere Prüf-docks und verwenden für den Einsatz ihrer Prüf-Docks zur Proxy Verwendung ihrer Tier-Binaries als Factory Pattern, in der Regel als Ausnahmen std::variant . Aber in den plain Tier-Binaries ist das verboten. Die hybrid-Tier-Binaries fahren eine Zwischenlösung zwischen statischen Prüf-Docks und austauschbaren plain Tier-Binaries je Prüfdock, das ist eine XML Konfiguration auf Wunsch des anwenders in der Auswertungsphase. Es ist auch einstellbar, dass die Anzahl der ABI stabilen Prüfdocks an der hybrid-Tier-Binary zahlenmäßig dynamisch variieren kann, genau dafür braucht es std::variant in einem wahlweise statischen oder runtime array.

Entscheid 2 - Die Meta-Meta-Achsen und deren Stempel-Einträge sind wie alle Hauptachsen PFLICHT, das gilt für ALLE Hauptachsen. Der stempel muss sich dynamisch per Metaprogrammierung den Anforderungen anpassen. Das ist eine Regression. Da eine Meta-Meta-Achse immer zu den Mess-Achsen, System-Achsen oder Organ-Achsen gehört, wird sie auch einfach dynamisch ans Ende der Kette in den bestehenden Zeilen angehängt. Merge Zeile kann daher nicht existieren, weil der PRT-ART Prüfling merge gegen die Organ-Achsen läuft. Die Markierung experimenteller Achsen-Algorithmen aus einem Prüfling wird in der Versionsbezifferung eines jeden Achsen-Algorithmus mit einem angehängten 'e' für ‚experimental' markiert. Die Realm Trennung ist damit derzeit defekt, was sich auf die Lagerhaltung auswirkt.

Entscheid 3 - Das Paket ist JETZT Pflicht, ansonsten müssen alle Binaries bei Einführung neu gebaut werden. Es ist die Basis des Systems, um mit den heute von infra installierten anderen OS die Bandbreite an binaries und Messungen zu erhöhen. Warum willst du die Grundlage der Wiederverwendbarkeit und Zuordbarkeit der Binaries nicht bauen, das System funktioniert sonst nicht?

Entscheid 4 - Ja bitte schärfen, heute kommt noch RISC-V und ein macOS M1 und macOS x86 dazu.

Entscheid 5 - Bitte nach Messfenster rotieren und bitte handout an infra.

Entscheid 6 - Fehlerklassen bitte jetzt mit bauen, wir haben genug credits und tokens parat.

Rückfrage 7 - E-24, E-19, E-02, E-23, E-21 sind jetzt PFLICHT. Der Rest nach der Abgabe auch PFLICHT.

Rückfrage 8 - Ja bitte jetzt durchziehen. Habich nicht ZU hingebungsvoll, er ist ein bescheidener und disziplinierter Mensch. Volles GO.

Rückfrage 9: Nein, ALLES genannte wird voll gebaut, wir haben die Ressourcen dafür."

## Auslegung + abgeleitete Pakete (Manager)

### E1 → HYBRID-TIER-STUFE (neue Architektur-Klärung, KERN)
- Eigene Stufe **HINTER der CEB**; trägt **mehrere ABI-stabile Prüf-Docks**; Prüf-Dock-Einsatz per **Factory Pattern als Proxy** auf ihre Tier-Binaries; dafür ausnahmsweise **std::variant** — in einem **wahlweise statischen oder Runtime-Array** (Dock-Anzahl dynamisch einstellbar).
- **Plain Tier-Binaries: std::variant bleibt VERBOTEN** (V7.2 gilt dort uneingeschränkt).
- Zwischenlösung statische Prüf-Docks ↔ austauschbare plain Tier-Binaries je Prüfdock = **XML-Konfiguration auf Anwender-Wunsch in der AUSWERTUNGSPHASE**.
- Konsequenz: V7.2-Präzisierung (Verbots-Scope = plain Tier-Binaries; Hybrid-Stufe = definierte Ausnahme). **Designplanung JETZT via Fable 5 xhigh + ultracode (Owner-Auflage); Bau in der Auswertungsphase.**

### E2 → STEMPEL-REGRESSION (trigger-blockierend!)
- Meta-Meta-Achsen-Stempeleinträge = PFLICHT wie alle Hauptachsen; Stempel passt sich **dynamisch per Metaprogrammierung** an.
- Meta-Meta gehört immer zu Mess-/System-/Organ-Realm → **dynamisch ANS ENDE der bestehenden Realm-Zeile anhängen** (keine Sonderzeile).
- **Die merge-Zeile DARF NICHT EXISTIEREN** (PRT-ART läuft merge GEGEN die Organ-Achsen). Ist-Stand 5-Zeilen-Layout (organ/system/measurement/merge/sha512, sizeof=136) ist damit **defekt** → Realm-Trennung defekt → wirkt auf die **Lagerhaltung**.
- Experimentelle Achsen-Algorithmen eines Prüflings: **'e'-Suffix in der Versionsbezifferung** je Achsen-Algorithmus.
- Konsequenz: Regression-Paket VOR Voll-Bau-4 (Stempel = Lager-/Skip-Identität): merge-Zeile entfernen, Meta-Meta-Anhängung bauen, 'e'-Versionierung einführen, OP-11 zurückbauen, G-E6/SHA512-Gate darauf aufsetzen.

### E3 → OS-UNTER-ACHSEN (FINAL DREI) JETZT PFLICHT (trigger-blockierend)
- Sonst Neubau ALLER Binaries bei späterer Einführung; Basis für die **heute von Infra installierten anderen OS** → Bandbreite an Binaries/Messungen. Grundlage der Wiederverwendbarkeit/Zuordbarkeit. (Owner-Rüge zur Nicht-Einplanung angenommen — Lehre: Frist-Sparsamkeit nie gegen System-Grundlagen.)

### E4 → Rang-3-Schärfung + NEUE PLATTFORMEN HEUTE
- K5-Framing schärfen (GO). **Heute kommen dazu: RISC-V, macOS M1 (ARM), macOS x86** → betrifft target_isa/operating_system-Achsen, Runner-Flotte, E-19-Soll, später Thesis-Nachzug (erst wenn real im Bestand).

### E5 → PAT-Rotation #327: NACH Messfenster; Handout an Infra JETZT.
### E6 → Fehlerklassen-Framework #29: JETZT mitbauen (Ressourcen vorhanden).
### R7 → **E-24, E-19, E-02, E-23, E-21 = JETZT PFLICHT**; Rest (inkl. E-25) = nach Abgabe ebenfalls PFLICHT (nichts entfällt).
### R8 → Thesis-Rahmen-Pass: volles GO. Danksagung Habich: **bescheiden + diszipliniert würdigen, NICHT überschwänglich**.
### R9 → E-04 **VOLLAUSBAU** vor Trigger (keine Minimalform). „ALLES genannte wird voll gebaut."

## NACHTRAG ~12:1x CEST — Owner-Antworten Q1/Q2 der Bauplan-Fragen (verbatim)

„Q1 - Wie empfohlen nach Klammern (derzeit auch so geplant, bitte nachlesen). Q2 - Die Merge strategie wird durchgeführt aber lebt in den Stempeln nur durch das bezifferte 'e' für experimentell und kann erweiterte Muster wie prt-art.memory.abc@1.0.0 nach sich ziehen, die cache engine macht das nach dem gleichen muster."

**Auslegung (bindend für A13):**
- **Q1 = KLAMMER-FORM.** Die Meta-Meta-Ebenen-Kodierung im Stempel folgt der bereits im Code kodifizierten Q-A-Auflage (Klammer-ANZAHL kodiert die Ebene; hardware_meta_meta_axis.hpp Kopf + :222-223/:281-283). Die Punkt-Pfad-Empfehlung des Designs ist VERWORFEN; A13-M2 baut die Klammer-Erweiterung des consteval-Zeilen-Parsers (anatomy_stamp_entries.hpp) als Pflichtteil. (Wichtig: Punkt-Pfade bleiben das Muster im ALGORITHMUS-NAMENSRAUM, s. Q2 — zwei verschiedene Namensräume, keine Kollision.)
- **Q2 = Strategie ohne eigenes Stempel-Feld.** Die Merge-Strategie wird DURCHGEFÜHRT, erscheint im Stempel aber NUR über das 'e'-Suffix der Versionsbezifferung; Differenzierung, wo nötig, über ERWEITERTE hierarchische Algorithmus-Namen nach dem Muster `prt-art.memory.abc@1.0.0` — die cache-engine nutzt dasselbe Namens-Muster. Damit ist die A13-Review-K-2-Frage (Lager-Key-Kollision zweier Strategien) über die Namens-Erweiterung zu lösen: unterschiedliche Merge-Konstellationen ⇒ unterschiedliche zusammengesetzte Algorithmus-Namen ⇒ unterschiedliche Stempel/SHA512. A13-M3 hat das als Design-Invariante durchzusetzen (CT-Wache: byte-verschiedene Merge-Binaries dürfen nie namensgleiche Organ-Segmente tragen).

## NACHTRAG ~17:0x CEST — Owner-Antwort Q3 (verbatim): FLAG-GRAMMATIK der Versionierung

„Die Kurzform ist verboten, Versionierungen sind einheitlich und immer 3-Stellig und beginnen mit 'v'. Das 'e' ist eine Flag und kann später gegen andere Falgs wie 'g' für GPU, 'c' für CPU, 'f' für FPGA und 'n' für NPU code erweitert werden. Wir produzieren nur CPU code, daher müssen alle Versionen mit 'c' oder 'ce' enden. Bitte halte das so fest"

**Auslegung (bindend, ersetzt die Q3-Empfehlungs-Implementierung aus A13-M1):**
1. **Form-Pflicht:** Versionen sind IMMER `vX.Y.Z` + Flags — dreistellig, beginnend mit 'v'. Die Kurzform (`v1`, `v1e`) ist VERBOTEN → Parser-seitig Sentinel. Der in A13-M1 per Empfehlung gebaute `v1e`-Kurzform-Zweig wird ZURÜCKGEBAUT.
2. **Flag-Familie:** Das Suffix ist eine FLAG-Position, erweiterbar: `c`=CPU, `g`=GPU, `f`=FPGA, `n`=NPU; `e`=experimental als Zusatz-Flag. Reihenfolge: Hardware-Flag zuerst, dann optional `e`.
3. **CPU-only-Pflicht:** Wir produzieren nur CPU-Code → ALLE Versionen enden mit `c` oder `ce` (z. B. `v1.0.0c`, `v2.3.4ce`). Eine Version OHNE Hardware-Flag ist ungültig.
4. **Konsequenz Bestand:** Die bestehenden `v1.0.0`-Strings (W12: 122× uniform) migrieren global auf `v1.0.0c` — das ist ein Stempel-/SHA512-Byte-Ereignis und wird in das EINE A13-M2/M3-Neuanker-Fenster gebündelt (vor Voll-Bau-4 existiert kein schützenswerter Bestand; kein zweiter Neuanker). Die A14-Bump-Verbots-Wache betrifft die Versions-NUMMER und bleibt unberührt.
5. **Wachen-Anpassung:** Die A13-M1-Wache „ce-Registry trägt nie 'e'" bleibt; NEU dazu: „jede Version trägt genau ein Hardware-Flag, im CPU-Scope 'c'" als CT-Wache. → Paket **A13-M1b** (Welle 2, vor/mit M2).

## Neue Paket-Wahrheit (Katalog-Deltas)
A7=E-04-Vollausbau · A13=Stempel-Regression (E2) · A14=OS-Unter-Achsen final drei (E3) · A15=Fehlerklassen-Framework #29 (E6) · A16=E-Pflicht-Bündel jetzt (E-24 als LETZTER ABI-Schritt in die Gate-Reihenfolge, E-19 Runner-Fleet-Soll+Poll-Jitter, E-02 Vier-Ledger-Struktur herstellen, E-23 API-Suchlauf, E-21 STACK/Verbose) · Hybrid-Tier: Design JETZT (ultracode), Bau=Auswertungsphase · D: PAT-Rotation nach Messfenster (Handout raus) · Plattform-Querschnitt: RISC-V + macOS M1 + macOS x86.

## NACHTRAG ~17:4x CEST — Owner-GO (verbatim): "Ok, volles Go fuer ALLE geplante offene Arbeit wie vorgegeben"

**Auslegung (bindend):** Die gesamte Bauplan-/Katalog-Strecke laeuft autonom weiter wie dokumentiert. Die noch offenen Bauplan-Fragen Q4-Q9 gelten mit ihren dokumentierten EMPFEHLUNGS-Defaults als freigegeben (Q4 CSV-Token nicht_gebaut; Q5 E-24 im EINEN ABI-Fenster, Graph-Gattung nach Abgabe; Q6 Ein-Gattung-Hybrid + MaxN=8 + LEDGER:187(e) superseded; Q7 PRUEF-TESTAT je Fenster; Q8 RT-Erhebung nach 27.07.-KERN; Q9 thesis-Ledger im Abgabe-Repo). Einspruch jederzeit moeglich; Abweichungen von Empfehlungen wuerden erneut vorgelegt. Messung selbst bleibt USER-GO-gated.

## NACHTRAG ~18:4x CEST — Owner-GO (verbatim): "Alles klar, volles GO für das pausenlose Durchziehen aller Wellen"

**Auslegung:** Alle Bauplan-Wellen laufen ohne Zwischen-Meldepausen durch (Welle 2b: A13-M2 Klammer-Parser + E04-P1 Marker v2 + A16-P2/P4; Welle 3: OS-U3 + A13-M3 + OD-10-RT, Codex-Klasse; danach W10, SHA512-Gate, Beweise, 12-Perm, E-04-Rest, J-Kette, Kalibrierlauf, Trigger). Gates bleiben unverändert scharf (Reviews, Doppellauf, gitleaks, R4); Messung bleibt USER-GO-gated.

## NACHTRAG ~19:1x CEST — Owner-Klarstellung Agenten-Grenze (verbatim)

„Hinweis: die Workflows von weniger als 8 gelten nur für das Programmieren aber nicht für die Planung."

**Auslegung:** Die A1-Grenze „bis zu 8 Agenten parallel" bindet NUR Programmier-/Bau-Worker (RAM-Begruendung); Planungs-/Design-/Review-Breiten (Fable-xhigh) sind davon ausgenommen. Der 13-Agenten-Design-Workflow und die Review-Staffeln waren damit konform; Bau-Wellen halten weiterhin <=8 gleichzeitige Worker.

## NACHTRAG ~19:5x CEST — Owner-Antwort Q10 (verbatim)

„Q10: Bitte ohne 'v' , lass es jetzt so, also Option A"

**Auslegung (bindend):** Das 'v'-Praefix gilt NUR fuer die Roh-Literale im Code (algo_version="vX.Y.Zc"); die GERENDERTE Stempel-Form bleibt praefixfrei (@X.Y.Zc nach der M3-Migration). Codex-Befund B9 ist damit GELOEST (kein Code-Aenderungsbedarf — die M1b-Implementierung ist korrekt); der M3-Neuanker rendert @1.0.0c.
