# INFRA-MELDUNG (SOFORT): Runner-Registration-Token-Rotation 286/288/289 + Rotationslisten-Aufnahme

**Von:** Lead-Session (Diplomarbeit Cache-Engine) · **An:** Infra · **Via:** Owner (Synchronisation)
**Datum:** 17.08.2026 · **Prioritaet:** SOFORT (Owner-Auftrag 17.08.)
**Owner-Wortlaut:** "Bitte sofort dem Infra melden und ueber mich synchronisieren, weil 5 Agenten
parallel arbeiten muessen und infra orchestrieren kann, wir koennen so gesteuert ein
Wartungsfenster sperren. Wir machen das sofort."

---

## 1. SACHVERHALT A-1: Registration-Tokens der GitLab-Projekte 286/288/289 sind in einer Leck-Menge

- Ein altes Backup-Output enthielt **390 Runner-Registration-Tokens im Klartext**
  (GR-Praefix-Familie). Der Scrub vom 02.08. hat die SPUR beseitigt, nicht die WIRKUNG:
  der read-only-Mengentest sagt fuer ALLE DREI Projekte (286, 288, 289) literal
  **"HEUTIGER TOKEN IST IN DER LECK-MENGE -> NICHT ROTIERT"**.
- Ein frueheres Owner-GO fuer genau diese Rotation lag vor; vollzogen wurden damals nur die
  CI-Variablen, nicht die Registration-Tokens.
- **Risiko:** Wer einen Registration-Token besitzt, kann einen Runner registrieren und damit
  Code in die Bau-/Mess-Kette bringen. Genau diese Kette traegt ab **26.08. 06:00** die
  W3-Messkampagne. Die Rotation muss VOR dem Bau-Trigger abgeschlossen sein.

### Auftrag an Infra (Owner-Entscheid 17.08.)
1. Rotation der Registration-Tokens der Projekte **286, 288, 289** in einem von Infra
   **gesperrten Wartungsfenster**.
2. Infra **orchestriert** das Fenster; die Fenster-Zeit wird **ueber den Owner synchronisiert**
   (5 Agenten arbeiten parallel auf der Instanz -- unkoordinierte Rotation wuerde laufende
   Zuege brechen).
3. Nach der Rotation: Gegenprobe, dass die Alt-Tokens ungueltig sind (Mengentest kippt auf
   "NICHT in der Leck-Menge"), und Bestandsaufnahme, welche Runner neu zu registrieren sind.

### Randbedingungen aus dem laufenden Betrieb (bitte einplanen)
- **Laufende CI-Pipelines NIE canceln** -- Fenster zwischen die Zuege legen; die Lead-Session
  meldet auf Owner-Anfrage jederzeit, ob ein Zug offen ist.
- **Runner-Flotte im Bestand:** prod1 (concurrent 3) + prod2 (concurrent 2) + 4 Windows-KVM-
  Runner + Cluster-Runner. Registration-Token-Rotation invalidiert NICHT die bereits
  registrierten Runner (deren Authentication-Tokens bleiben) -- es verhindert NEUE
  Fremd-Registrierungen. Neuregistrierung nur noetig, wo Runner ohnehin neu aufgesetzt werden.
- **Die 286er-Mess-Pipeline ist ein Mehrtages-Experiment: NIE pollen, NIE anfassen.**
- **D-3 ENTSCHIEDEN (Owner 17.08., "Wie empfohlen"):** Registration-Tokens werden INSTANZWEIT
  ABGESCHALTET (`allow_runner_registration_token=false`) und die Flotte auf
  Runner-Authentication-Tokens umgestellt -- das macht die ganze Leck-Klasse (GR-Format)
  dauerhaft gegenstandslos. Sinnvoll im SELBEN Wartungsfenster wie die Rotation; Reihenfolge
  (erst rotieren, dann abschalten -- oder direkt abschalten) liegt bei Infra.

## 2. SACHVERHALT A-2: Vault-Eintrag samba-comdare-socks-pw in die Rotationsliste

- Der Wert geriet bei einem maskierten sed-Lauf im Klartext in ein Session-Transkript
  (Positions-Regex griff 6 statt 40 Zeichen). **Entlastung:** das Konto existiert im
  Live-AD derzeit NICHT.
- **Owner-Entscheid 17.08.: in die Rotationsliste aufnehmen** ("Ja aufnehmen, auch direkt an
  infra"). Zweck: verhindert, dass ein spaeter wiederbelebtes Konto mit dem kompromittierten
  Alt-Passwort startet. Kein Wartungsfenster noetig -- reine Listen-Aufnahme; Rotation faellig,
  falls/sobald das Konto wieder angelegt wird.

## 3. Kontakt / Synchronisation

- Rueckfragen und Fenster-Terminierung ausschliesslich **ueber den Owner** (der koordiniert
  die 5 parallel arbeitenden Agenten).
- Diese Meldung enthaelt absichtlich KEINE Token-Werte, keine Klartext-Passwoerter und keine
  Vault-Inhalte -- nur Eintrags-NAMEN und Projekt-IDs. Die Leck-Mengen-Belege liegen in den
  Session-Unterlagen der Lead-Session und koennen auf Owner-Anforderung blind (Laenge/Hash)
  nachgewiesen werden.
