## NACHTRAG 11.08.2026 NACHTS — KON15: DIE OWNER-ANTWORTEN AUF DIE SYNTHESEN

**Sechs Antworten auf KON14. Zwei sind Freigaben, zwei sind Korrekturen an meiner Deutung, eine ist
ein letztes Wort, eine ein Explore-Auftrag.**

---

### KON15-01 — LEERE KLASSEN WERDEN NOTIERT, NICHT ÜBERGANGEN

**Owner auf KON14-01** (die widerlegten Messungen): *„Dann müssen wir noch **leere Klassen
notieren und später implementieren**, sofern sie in den Wellen noch bearbeitet werden sollten."*

Die Inventur hat gezeigt, dass Kategorie 4 („0 Aufrufer überhaupt") **leer** ist — aber sie hat
nicht geprüft, ob eine Klasse **leer im Inhalt** ist. Das ist eine andere Frage: eine Klasse kann
Aufrufer haben und trotzdem ein Rumpf sein.

⇒ **Neuer Bau-Posten: das Register der leeren Klassen.** Erfassen, welche Klassen/Strukturen im
Bestand nur Hülle sind, und je Eintrag prüfen, ob eine **Welle sie noch anfasst**. Wo ja: als
Implementierungs-Posten in die Welle. Wo nein: als benannte Grenze führen, nicht stillschweigend
mitschleppen.

---

### KON15-02 — 🔴 S-6 IST NICHT EINFACH „FALSCH HERUM". ES SIND ZWEI WELTEN.

**Owner auf KON14-02:** *„Das kommt immer noch darauf an, **ob im Lager oder außerhalb des Lagers**
verwendet, das sind **zwei Welten für die Reihenfolge der Glieder** (explore)."*

**Meine Fassung war zu einfach.** KON14-02 hat die Preimage-Reihenfolge
`organ → system → measurement` pauschal als falsch geführt. Richtig ist: **die Reihenfolge ist
kontextabhängig**, und es gibt zwei Welten.

Das deckt sich mit dem bereits belegten Lager-Befund (**D-12**): das Lager trägt **zwei Kaskaden** —
Messdaten `MESS→SYSTEM→ORGAN`, Binaries `SYSTEM→ORGAN→MESS`. Und mit der Ausnahme aus KON7:
*„nur das Lager hat hier eine Ausnahme für die Übermittlung von Funktionsvariablen."*

⇒ **Explore-Auftrag vor jeder Änderung an S-6:** welche Reihenfolge gilt **im Lager**, welche
**außerhalb**, und wo verläuft die Grenze im Code? **Bis dahin wird an der Glieder-Reihenfolge
nichts gebaut** — eine pauschale Umstellung würde eine der beiden Welten brechen.

---

### KON15-03 — VOLLES GO: DIE ZITAT-REGEL

**Owner auf KON14-03** (die vier unmarkierten Eingriffe in KON9-11): *„Volles Go."*

Die Regel gilt ab sofort ohne Ausnahme: **jede Kürzung in einem Owner-Zitat trägt `[…]`.**
Ein still gekürztes Zitat ist ein verändertes Zitat — und der vierte Eingriff hatte ein Ende
**vor einem Blocker-Folgesatz** gekappt.

---

### KON15-04 — VOLLES GO: DIE VIER ZAHLEN NACHHOLEN

**Owner auf KON14-04:** *„Volles GO zum nachholen."*

    295 -> 294   static_assert in algo_semver.hpp
    137 -> 123   Flag-Literale (97x 1.0.0.c, 24x 1.0.2.c, 2x 1.0.1.c); Differenz 14 unaufgeklaert
    124 -> 130   Header unter axes-Pfad mit algo_version (davon 104 mit echter Zuweisung)
    13/7967 -> 14/8528   ci/tests/*.sh, 0 von 14 retired
    bump-pflichtige Menge = 152 (130 axes + 22 Queuing), nicht 130

---

### KON15-05 — 🔴 DIE CACHE-LANDSCHAFT: DAS LETZTE WORT

**Owner auf KON14 / die Vokabular- und Mount-Fragen, wörtlich:**

> *„**local** sind **Dateisysteme lokal oder Netzwerk**, **minio** ist effektiv **S3 Speicher im
> Netzwerk**. Runner dürfen bitte **nur den ccache auf `minio.comdare.de` und das neue
> Buildsystem-NAS lesen**. **Das ist mein letztes Wort dazu.**"*

**Damit sind drei offene Fragen auf einmal beantwortet:**

    VOKABULAR   local  = Dateisystem, lokal ODER im Netz   (kein Widerspruch zu "Filesystem")
                minio  = S3-Speicher im Netz
                -> das bestehende XSD-Enum {local, minio} TRAEGT die Owner-Semantik.
                   Der s3-Fehlertest bleibt gueltig: "s3" ist kein Backend-Name, sondern
                   die Technik hinter "minio".

    RUNNER-ZUGRIFF   Runner duerfen LESEN:  (1) ccache auf minio.comdare.de
                                            (2) das neue Buildsystem-NAS
                     Sonst nichts. LETZTES WORT.

    MOUNT-FRAGE      damit beantwortet: der Buildsystem-NAS ist fuer Runner lesbar.
                     Die 12.07.-Doktrin ("Runner duerfen Cluster_NFS NIE lesen") bleibt
                     fuer Cluster_NFS gueltig -- der Buildsystem-NAS ist ein ANDERER Ort.

**Was daraus für S-13 folgt:** kein neues Vokabular, kein Schema-Bruch. Der inerte
`<storage backend="local|minio">`-Slot ist **erweiterbar**, nicht zu ersetzen — er trägt die
Owner-Semantik bereits. Was fehlt, ist die **Drei-Ziele-Struktur** darüber und je ein zweiter
Backend-Weg.

**Und der dritte Ort bleibt außerhalb der Runner-Leseberechtigung:** `cache-engine-experiment` im
Cluster_NFS ist **Ausgabe**-Ort — dorthin wird geschrieben (über den Filterpod), nicht gelesen.

---

### KON15-06 — WAS DAMIT VON DEN NEUNZEHN FRAGEN BLEIBT

    BEANTWORTET durch KON15:   Vokabular (F-11) · Mount/Filterpod (F-9) · Schema-Form (F-10, teilweise)
    NEU ENTSTANDEN:            das Register der leeren Klassen (KON15-01)
                               die Zwei-Welten-Frage der Glieder-Reihenfolge (KON15-02, Explore)

Die verbleibenden Fragen stehen in der Kontextübergabe
`docs/sessions/20260811-KONTEXTUEBERGABE-nacht-7b-*` und in der Owner-Vorlage
`docs/plaene/20260811-OWNER-VORLAGE-*`.
