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

## Neue Paket-Wahrheit (Katalog-Deltas)
A7=E-04-Vollausbau · A13=Stempel-Regression (E2) · A14=OS-Unter-Achsen final drei (E3) · A15=Fehlerklassen-Framework #29 (E6) · A16=E-Pflicht-Bündel jetzt (E-24 als LETZTER ABI-Schritt in die Gate-Reihenfolge, E-19 Runner-Fleet-Soll+Poll-Jitter, E-02 Vier-Ledger-Struktur herstellen, E-23 API-Suchlauf, E-21 STACK/Verbose) · Hybrid-Tier: Design JETZT (ultracode), Bau=Auswertungsphase · D: PAT-Rotation nach Messfenster (Handout raus) · Plattform-Querschnitt: RISC-V + macOS M1 + macOS x86.
