## BEFUND-VORBEHALT (methodisch, zwingend zuerst)

Drei der vier Owner-Originale stehen NICHT im beauftragten Verzeichnis. Ursache belegt: der
Plaintext-Extraktor hat alle Owner-Nachrichten verworfen, die als
`"attachment":{"type":"queued_command","prompt":"..."}` im jsonl liegen (getippt-waehrend-Agent-laeuft).
Zaehlung: `grep -c queued_command` = **982** Records im Quell-jsonl, **0** davon in den 32 verlauf-Dateien.
Gegenprobe: `grep -c 'per XML deaktiviert'` und `grep -c 'Haupt-Achsen sind compile time statisch'`
ueber `verlauf-*.txt` = **0 Treffer**; `'Lager inventarisieren'` = 1 Treffer, aber nur als
Assistant-Paraphrase (verlauf-32.txt:307). Autoritative Quelle daher:
`/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl`
(= dieselbe Quelle, aus der das Backup erzeugt wurde). Zeilennummern unten sind jsonl-Zeilen.
=> Das Backup `20260726-session-plaintext-verlauf/` ist fuer Entscheid-Antworten LUECKENHAFT;
Redaktions-Pass sollte um `attachment.queued_command.prompt` erweitert und neu erzeugt werden.

---

## (1) Q-1 disk_writeback enabled=false

**Owner-Zitat (wortgenau, transliteriert):**
> "Q-1: Wie empfohlen, korrekt. Die Achse wird per XML deaktiviert und das muss unterstuetzt sein."

**Stelle:** jsonl:79891 (queued_command, 2026-07-26T13:18:19.928Z). NICHT im Backup-Verzeichnis.
**Kontext:** Owner beantwortet in einem Block Q-0..Q-14 des STRUKT-R-Bauplans; die referenzierte
Empfehlung steht wortgleich in `verlauf-32.txt:52` bzw. `verlauf-31.txt:1475` (kein echter
Disk-Schreibpfad, "Messwert-Luege" gegen honest-100%, enabled=false, Raum bleibt 2^17, per option()
aufschaltbar).

**VERDIKT: BESTAETIGT (per Uebernahme "wie empfohlen"), mit zwei Abweichungs-Nuancen:**
- (a) "kein echter Disk-Pfad = Messwert-Luege" und "Raum 2^17" sind **Assistant-Worte**, vom Owner nur
  durch Referenz uebernommen - kein Owner-Wortlaut. Dossier-Formulierung ist also korrekt in der
  Sache, aber nicht owner-verbatim begruendet.
- (b) Owner sagt "**Die Achse** wird per XML deaktiviert"; die Empfehlung sagte "Achse vollstaendig
  einbauen, **Baustein** disk_writeback enabled=false". Die XML-Deaktivierbarkeits-PFLICHT ist
  owner-verbatim ("das muss unterstuetzt sein"); die Achse/Baustein-Trennung ist NICHT literal
  zugesprochen - hier ist eine Praezisierungs-Rueckfrage sauber, statt sie zu unterstellen.
- Nebenbefund derselben Nachricht (relevant fuer den Fahrplan): "Ich akzeptiere V2 Byte-Schnitt,
  volles GO. Ich wuensche mir dennoch V3 direkt mit rein, die Maschinen verkraften den Voll-Bau
  durch vorangegangene Optimierungen jetzt besser."

---

## (2) A-1 Truncate-Regeln Bestandslog

**Owner-Zitat (wortgenau, transliteriert):**
> "A-1: Genau das ist korrekt und bedacht, in der Regel aufraeumen am Ende eines builds fuer 'Lager
> inventarisieren' oder truncate ad hoc bei einer bestimmten Groesse von mehr als 4KB nur im Sicheren
> Zustand (eine Maschine hat ein lock auf den Knoten ergattert und schreibt als einzige)."

**Stelle:** jsonl:79936 (queued_command, 2026-07-26T13:21:36.479Z). NICHT im Backup-Verzeichnis.
**Kontext:** Owner bestaetigt die Retention-Lesart, die der Manager als A-1 mit Kontext nachgereicht
hatte (`verlauf-32.txt:47`).
**Vorlaeufer-Zitat derselben Doktrin (Abnahme 2, jsonl:79807, 13:01:27.805Z):**
> "(Bug Quelle ist das truncaten von logs das regelmaessig, aber nur im Schluss-Zustand gemacht
> werden darf)"

**VERDIKT: BESTAETIGT - wortgenau und vollstaendig deckungsgleich.** Alle drei Dossier-Elemente sind
Owner-Wortlaut: Build-Ende ("aufraeumen am Ende eines builds"), >4KB ("mehr als 4KB"), Knoten-Lock
("nur im Sicheren Zustand ... lock auf den Knoten"). Zusatz-Praezision im Original, die das Dossier
knapper fasst: das Lock-Kriterium ist als **Alleinschreiber-Eigenschaft** definiert ("schreibt als
einzige"), und der Build-Ende-Fall ist der REGELFALL, >4KB der AD-HOC-Fall.
(Diese Fassung liegt bereits korrekt im Memory
`project_bestandslog_abnahmen_baum_heuristik_stempel.md`, Punkt 5b.)

---

## (3) R-F SIMD/AVX = Meta-Meta-Achsen

**Owner-Zitat 1 (Erstnennung, wortgenau, transliteriert):**
> "Daher ist die Registrierung auch durch branching auf der System-Achse durch Meta-Meta-Achsen (zu
> denen auch AVX und SIMD gehoeren -> weitere Regression) multithreading faehig"

**Stelle:** jsonl:79807 (Abnahme 2, queued_command, 13:01:27.805Z). NICHT im Backup-Verzeichnis.

**Owner-Zitat 2 (Praezisierung, IM beauftragten Verzeichnis vorhanden):**
> "Q-B: (i) bitte. ext_hw ist der plug und manager der Meta-Meta-Achsen und sollte besser
> extermal_utils heissen, wozu auch externe hardware gehoert, aber auch das Mess-Framework als stets
> erster Einbaukandidat, aber auch AVX als Hardware Erweiterung."

**Stelle:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-32.txt:896`
(= jsonl:80156, getippt, 13:51:33.552Z).
**Kontext:** Erstnennung fiel als Nebensatz in der Abnahme-2-Baum-Erklaerung; Q-B ist die Antwort auf
die Nachfrage, wo die Meta-Metas dann haengen.

**VERDIKT: BESTAETIGT und darueber hinaus PRAEZISIERT.** Owner-verbatim: AVX und SIMD gehoeren zu den
Meta-Meta-Achsen, ausdruecklich als "weitere Regression" markiert - also nicht Unter-Achse von
extension_hardware. Zwei Ergaenzungen, die im Dossier-Stand fehlen und nachgezogen werden muessen:
(a) ext_hw ist nicht weg, sondern **plug und manager (Hub)** der Meta-Meta-Achsen und soll
**umbenannt** werden ("extermal_utils" - Owner-Schreibweise, Rueckfrage auf "external_utils"
angebracht); Mess-Framework ist dort erster Einbaukandidat.
(b) Meta-Meta-Achsen sind selbst **Haupt-Achsen, die eigene Unter-Achsen tragen** (jsonl:79891, Q-2),
und ihre Identitaet ist nur **aufwaerts** kompatibel: "Alle Teil-Identitaeten mit kleinerer
Hardware-Verwendung sind gueltig ... (ausser load_framework)" (`verlauf-31.txt:1281`).

---

## (4) CT/RT-strikt-XOR-Haertung

**Owner-Zitat 1 (die Regel, wortgenau, transliteriert):**
> "Q-2: Das OS ist keine Unter-Achse, sondern eine Komplex-Haupt-Achse, bitte lies nochmal
> gruendlich. Haupt-Achsen sind compile time statisch und Unter-Achsen sind laufzeit-dynamisch. Das
> ist geplant und dokumentiert, es gibt jetzt neue Layer in den Haupt-Achsen, zu deren command
> pattern und Rekursivitaet auch die Meta-Meta-Achsen als Haupt-Achsen gehoeren, die selbst
> Unter-Achsen tragen. Bitte ultracode, hier stimmt das Verstaendnis ueber die letzte Woche gar nicht."

**Stelle:** jsonl:79891 (queued_command, 13:18:19.928Z). NICHT im Backup-Verzeichnis.

**Owner-Zitat 2 (Stufen-Relativitaet + Kriterium, IM beauftragten Verzeichnis vorhanden):**
> "Und ich habe vergessen, dass load_framework eine Laufzeit-Unterachse auf dem Planer ist und eine
> compile-time Haupt-Achse auf der CEB, dasselbe gilt ja technisch gesehen auch fuer das
> Mess-Tooling." ... "Der compiler ist eine Unter-Achse weil er ein zur Laufzeit austauschbares
> Programm ist aus Sicht der CEB, dasselbe gilt fuer opt_level/atomic_128."

**Stelle:** `.../20260726-session-plaintext-verlauf/verlauf-31.txt:1281` (= jsonl:79475, getippt,
12:03:39.908Z).
**Kontext:** Owner korrigiert das Achsen-Verstaendnis waehrend der Lager-Baum-Ordnung und nennt
dabei das Zuordnungs-Kriterium (zur Laufzeit austauschbar => Unter-Achse).

**VERDIKT: BESTAETIGT, mit einer Wortlaut-Abweichung und einer Schaerfung.**
- Das Wort "XOR" ist **Dossier-Sprache**, nicht Owner-Sprache: der Owner formuliert es als positive
  Doppel-Zuordnung ("Haupt = compile time statisch UND Unter = laufzeit-dynamisch"). Als Bikonditional
  ist das aequivalent - die Haertung darf so gebaut werden, sie ist aber nicht literal "XOR" genannt.
- "stufen-relativ" ist **owner-belegt** und zwingend: dasselbe Konzept ist RT-Unter-Achse auf dem
  Planer und CT-Haupt-Achse auf der CEB (load_framework, Mess-Tooling). Eine global-absolute
  Haertung waere also eine Regression.
- Gegen-Beleg-Falle im selben Block, unbedingt mitnehmen: "Q-13 (doch Telemetry ist Mess-Tooling
  Unterachse von Planner)" - der Owner hat hier die Assistant-Empfehlung ueberstimmt; wer Q-13 als
  "wie empfohlen" verbucht, baut falsch.
