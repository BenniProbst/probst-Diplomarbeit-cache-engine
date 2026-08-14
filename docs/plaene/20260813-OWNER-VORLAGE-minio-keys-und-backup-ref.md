# OWNER-VORLAGE 13.08.2026 — MinIO-KEYS UND DIE VERSCHWUNDENE BACKUP-REF (Task #10)

> **Zwei Entscheide, beide nicht durch Explore aufloesbar (KON41-05-Klasse). Je Frage ein Satz,**
> **Empfehlung dabei. Der System-Test haengt an Frage 1.**

---

## FRAGE 1 — MinIO-KEYS NEU ERZEUGEN (blockiert jeden MinIO-Systemtest)

**Die Frage in einem Satz:** Erzeugst du (oder Infra) ein neues MinIO-Access/Secret-Paar fuer
minio.comdare.de und traegst es in den Cred-Vault ein — oder nennst du einen anderen Ort, an dem
ein gueltiges Paar liegt?

**Recherche-Weg (vollstaendig gefahren, 13.08.):**
- KON22-01/5 (Owner): *"Die keys minio wurden vom scrub mitgenommen. Du musst sie aus Cluster
  git cred vault neu suchen und neu einsetzen, um das System zu testen."*
- BLIND-SMOKE v2 am 13.08. (Werte verlassen das Werkzeug nie): BEIDE Vaults
  (CREDENTIALS-VAULT-DEV.md 646 Z., CREDENTIALS-VAULT-PROD.md 525 Z.), BEIDE Endpunkte
  (minio.comdare.de:9000, minio.comdare.local:9000), alle minio-Zeilen RUECKWAERTS:
  9 Zeilen als "entwertet" markiert und uebersprungen · 5 Zeilen mit 2-3 Kandidaten, alle
  Paar-Rollen ROT. **KEIN PAAR GRUEN.**
- Die Null ist GEDECKT: der Koeder-Lauf (Zufalls-Paar) liefert an beiden Endpunkten rc=1 —
  die Mechanik beisst, die Null kommt nicht vom Werkzeug.
- Die 4 Kern-Variablen in Projekt 288 EXISTIEREN (API-Existenz-Check, protected+masked) —
  ob ihre WERTE funktional sind, ist ohne gueltiges Vergleichspaar bzw. ohne Mess-Lauf mit
  MinIO-Rueckschrieb nicht pruefbar.

**Empfehlung:** neues Paar erzeugen (MinIO-Admin = Infra-Territorium, A5), im Vault als
NEUE Zeile eintragen (additiv, alte "entwertet"-Zeilen bleiben), dann setze ich die
288-Variablen blind neu (Vault -> API, Praezedenz KON46-03) und der naechste
measure-Lauf mit Rueckschrieb ist der Funktionsbeweis.

**Was der Entscheid freischaltet:** ##56-Rueckschrieb (W3, F4) · S-13-Tests (W2) ·
die Zweitlanigkeit Gen-2 (Bestandslog auf minio).

**Frist-Empfehlung:** vor W2 (Mo 24.08.) — der Kalibrierlauf ##47 (Di 25.08.) faehrt durch
die Gates, und der Rueckschrieb-Pfad sollte dort nicht zum ersten Mal live gehen.

---

## FRAGE 2 — DIE VERSCHWUNDENE BACKUP-REF (nur Verbuchung, keine Eigenmassnahme)

**Die Frage in einem Satz:** Die Backup-Ref `refs/backup/pre-secret-scrub-20260802` ist von
BEIDEN Origins verschwunden, ohne dass ein Bundle oder ein gegenstands-genaues GO im Ledger
steht — bestaetigst du die Loeschung nachtraeglich, oder soll die Ref (falls lokal noch
rekonstruierbar) neu gesichert werden?

**Lage:** KON22-02 legte die GESTUFTE Form fest (stehen lassen -> nach der Lieferphase
rechtebeschraenktes Bundle -> ERST DANN Remote-Loeschung mit ausdruecklichem GO). Der
A-1-Vorlagetext (Ledger-IV/M) verlangt VOR jeder Backup-Ref-Aktion die Vorlage — sie liegt
hiermit vor. Ich habe NICHTS geloescht und werde nichts loeschen; die Ref fehlt remote
bereits, Verursacher unbekannt.

**Empfehlung:** falls ein lokaler Klon die Ref noch traegt: sofort als Bundle sichern
(additiv), dann deine Entscheidung ueber die Remote-Seite. Ich pruefe die lokalen Klone
auf die Ref, sobald du es freigibst — die Pruefung selbst ist lesend und gefahrlos, aber
sie gehoert nach A-1 erst NACH dieser Vorlage.

---

## NACHTRAG 13.08. (#21/BAU) -- FRAGE 2 IST DURCH ROH-TRANSKRIPT-BEFUND UEBERHOLT

Der Verursacher ist NICHT unbekannt, und es braucht KEINE nachtraegliche Bestaetigung --
die Kette liegt vollstaendig im Rohtranskript der 10.08.-Session
(5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl; Owner-Zitate als ASCII-Transliteration):

1. **Z. 35872 (12:20:53Z), A-1-Vorlage:** "A-1 - GO fuer die Loeschung von
   refs/backup/pre-secret-scrub-20260802. 776 Runner-Token, alle in einem Commit, der an
   keinem Branch haengt. [...] Empfehlung: loeschen, danach Vollscan als Beleg 776 -> 0."
2. **Z. 35912 (12:40:23Z), Owner:** "A-1: volles GO." -- das GO deckte die LOESCHUNG
   direkt und gegenstands-genau.
3. **Z. ~35913-35944 (bis 12:43Z):** Loeschung ausgefuehrt (git push origin --delete +
   git update-ref -d; Nachweis "Backup-Refs auf origin: 0"; GitHub war vorher schon leer).
4. **Z. ~36022-36039 (12:50-12:52Z):** korrigierter Vollscan MIT --log-opts=--all
   (der erste Beleg deckte nur HEAD): super 6634 Refs/6538 commits "no leaks found";
   ce beide Remotes 3374 commits "no leaks found".

**FRAGE 2 wird damit zur KENNTNISNAHME-Mitteilung:** Loeschung war owner-autorisiert und
ist belegt; es fehlte allein die Ledger-Buchung (liegt dem Lead jetzt als KON-Nachtrag
vor; KON22-02 ist als Fehl-Rekonstruktion markiert, KON58-04 Befund 3 aufgeloest). Ein
Bundle existiert nicht und war nicht Teil der genehmigten Empfehlung. Der oben erbetene
Klon-Sweep entfaellt als Ref-Frage und wandert als Token-Hygiene-Punkt zur A-3-Rotation.
**FRAGE 1 (MinIO-Keys) bleibt unveraendert offen und dringend.**
Referenz: docs/plaene/20260813-OWNER-VORLAGE-a1-backup-ref-aktionen.md (Vorlage-Form +
ausgefuellte Fassung + E-1..E-4-Bilanz).
