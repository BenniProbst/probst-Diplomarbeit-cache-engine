# I113 — Runner-Token-Rotation, Keys und Infra-Restposten

**Stand:** 2026-08-06, spaeter Abend
**Absender:** Diplomarbeits-Implementierungslinie (Lead)
**Empfaenger:** Infra-Agent
**Owner-Zuweisung, verbatim:** *"Bitte handout mit commit und push an den infra Agenten fuer
rotationen, keys und allgemeine infra Probleme. Das ist nicht mehr dein Problem."*

**Sicherheitsauflage fuer dieses Dokument:** es enthaelt **keine Geheimniswerte** und darf
auch kuenftig keine tragen. Alle Befunde sind so formuliert, dass sie ohne Klartext
nachvollziehbar sind.

---

## P-1 — AKUT: 390 GitLab-Runner-Registration-Token sind NICHT rotiert

**Schwere: hoch. Einziger Posten dieses Handouts mit laufendem Schadenspotenzial.**

### Der Befund

Am 02.08.2026 hat der E23-Scrub 390 Runner-Registration-Token per `filter-branch` aus der
Git-Historie entfernt. **Die Spur wurde beseitigt — die Wirkung nicht.**

Heute read-only nachgemessen (Mengentest per API, **ohne einen einzigen Wert auszugeben**):

    ce      (Projekt 286): heutiger runners_token IST in der Leck-Menge  -> NICHT ROTIERT
    super   (Projekt 288): heutiger runners_token IST in der Leck-Menge  -> NICHT ROTIERT
    thesis  (Projekt 289): heutiger runners_token IST in der Leck-Menge  -> NICHT ROTIERT

Verfahren: `GET /api/v4/projects/<id>` liefert `runners_token`; dieser wurde gegen die Menge
der 390 geleakten Werte geprueft. Kein Klartext verlassen die Pruefung.

### Warum das zaehlt

Wer einen dieser Token besitzt, kann einen **Runner registrieren** und damit Jobs des Projekts
ausfuehren — also CI-Geheimnisse abgreifen und Code in die Bau-Kette bringen. Bei einer
Diplomarbeit mit mehrtaegigen Messlaeufen ist das zusaetzlich ein Integritaetsrisiko fuer die
Messdaten.

### Herkunft und Fundstelle

- Quelle der Werte: `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/projects_all.ndjson`
  (390) und `group_projects.ndjson` (386), Feld `runners_token`, Commit `44820451`.
- Der Vorzustand lebt nur noch in den **lokalen** Refs `refs/backup/pre-secret-scrub-20260802`
  und `refs/original/refs/heads/development`. `44820451` ist **kein Vorfahr von HEAD**.
- Arbeitsbaum und `development` sind heute token-frei (0 Treffer, gegengeprueft).

### Zweiter Weg, auf dem sie beinahe zurueckgekehrt waeren

Ein frueherer `gitleaks`-Lauf druckt in seinen `Finding:`/`Secret:`-Zeilen den **Klartextwert**.
Ein Agent hat diesen Konsolen-Auswurf woertlich in seinen Bericht kopiert; der Bericht lag in
einem Workflow-Backup, das zum Push vorgesehen war. **Abgefangen.**

- Original in Quarantaene: `/home/comdare/backups-workflow/QUARANTAENE/bnpj776mm.output`
  (Datei 0600, Verzeichnis 700).
- Im Repo liegt nur `…/outputs/bnpj776mm.output.REDACTED` — bit-gleich bis auf 1552
  mechanisch ersetzte Werte. Nachgemessen: **0 volle Token** im Commit, Gegenprobe am Original
  findet 1552 (das Verfahren misst also).

### Was der Infra-Agent tun muss

1. **Die drei Projekt-Token rotieren** (286 ce, 288 super, 289 thesis). Danach denselben
   Mengentest wiederholen — er muss "nicht in der Leck-Menge" liefern.
2. **Bestehende Runner neu registrieren**, sonst faellt die CI aus. Reihenfolge beachten:
   erst neue Registrierung vorbereiten, dann rotieren.
3. **Die uebrigen 387 Token** gehoeren zu Fremdprojekten desselben GitLab. Das ist eine
   getrennte Entscheidung — Umfang und Zustaendigkeit liegen nicht bei der Diplomarbeit.
4. **Die lokalen Backup-Refs** (`refs/backup/pre-secret-scrub-20260802`,
   `refs/original/…`) entscheiden: behalten (dann bleiben die Werte lokal lesbar) oder
   entfernen. **Loeschung braucht ausdrueckliches Owner-GO** — Doktrin.
5. **Quarantaene-Datei**: entscheiden, ob sie erhalten bleibt. Sie ist der einzige Beleg fuer
   den Umfang des Lecks.

### Praevention, die aus dem Vorfall folgt

`gitleaks` gibt Klartext aus. **Jede Weitergabe eines gitleaks-Laufs (Bericht, Log, Ticket)
muss vorher redigiert werden.** Und: eine Vorpruefung, die nach `glpat-`/`ghp_`/PEM sucht,
deckt Runner-Token **nicht** ab — deren Praefix ist `GR1348941…`.

---

## P-2 — `gitleaks` ueber Submodule meldet still GRUEN

**Schwere: mittel, aber es betrifft jede Sicherheitspruefung im Projekt.**

Ein `gitleaks`-Lauf gegen ein Submodul-Verzeichnis meldet woertlich `no leaks found` — bei
**`0 commits scanned`**. Ursache: in einem Submodul ist `.git` eine *Datei* mit
`gitdir: ../../../.git/modules/…`; im Container laeuft dieser Zeiger ins Leere.

**Falsch (meldet gruen, prueft nichts):**

    podman run --rm -v "$CE":/repo:ro,Z gitleaks git /repo --log-opts "A..B"

**Richtig (Elternrepo mounten, Scan-Ziel im Mount):**

    podman run --rm -v "$SUPER":/super:ro,Z gitleaks \
      git /super/Code/external/comdare-cache-engine \
      --config /super/Code/external/comdare-cache-engine/.gitleaks.toml \
      --log-opts "A..B" --redact --no-banner

**Bitte in ein Skript giessen, das den Nenner ausgibt** (`N commits scanned`) und bei `0`
**abbricht statt gruen zu melden**. Die Falle ist heute zweimal aufgetreten — beim ce-Submodul
und, keine zwei Stunden nach ihrer Dokumentation, erneut beim thesis-Submodul. Sie greift
nur, wenn jemand die Zeile mitliest; das ist kein Verfahren.

---

## P-3 — `xmllint` auf den baremetal-Runnern unbelegt (Owner-Entscheid O-D)

Fuenf super-Tests brechen ohne `xmllint` mit `FATAL_ERROR`
(`Code/tests/xml_canonical_utils.cmake`). Eine Repo-weite Suche findet **keine Fundstelle**,
die die Praesenz auf prod1/prod2 belegt.

**Frage an Infra:** ist `libxml2-utils` auf beiden baremetal-Runnern und auf den 8
Docker-Distros installiert? Falls nein: nachinstallieren (Cluster-Schreibrecht noetig).
Die Alternative — die Wachen herausnehmen — waere ein stiller Skip und widerspricht der
Skip-Disziplin der Datei.

---

## P-4 — Runner-Zahlen OD-7: Soll gegen Ist unklar

Owner-Direktive: normal 2/2 x 12 auf beiden Hosts, heavy prod1 **24**.
Zwei Berichte widersprechen sich (einer nennt "3/2 + heavy auf 16 gekappt", ein zweiter haelt
diese Zahl selbst fuer stale und sagt, offen sei nur NORMAL mit 4/4 statt 2x12; HEAVY sei
konform). **Eine Live-Verifikation am Host steht aus.**

Zusatz-Verdacht aus einem Bericht, ungeprueft: eine **Tag-Falle** `baremetal` gegen
`bare-metal` klemmt super-Jobs auf einen einzigen Runner (id=16).

---

## P-5 — Platzpflege vor dem Voll-Bau

Der anstehende Voll-Bau umfasst mehrere hunderttausend Tier-Binaries ueber ~34 h Wanduhr.
Letzter bekannter Stand (05.08.): prod1 **60 G frei / 75 % belegt**, prod2 **141 G**.

Offen: `builds_dir`/`cache_dir`-Umzug auf die groessere Lane, ein Cleaner, und ein Test von
`FF_USE_LEGACY_S3_CACHE_ADAPTER=false`. **Waehrend des Voll-Baus ist eine `df`-Wache auf
beiden Maschinen Pflicht** (Doktrin Paragraf 65) — ein volllaufendes Dateisystem mitten im
Lauf ist der teuerste denkbare Abbruch.

---

## Was NICHT Infra ist — zur Abgrenzung

Zwei Posten sahen heute nach Infra aus und sind es **nicht**. Damit niemand daran arbeitet:

1. **`pmc:intel` fiel rot** — die naheliegende Vermutung war ein Rechteproblem.
   **Widerlegt:** `perf_event_paranoid = 1` auf **beiden** Maschinen, identisch, gleicher
   Kernel (6.17.0-35-generic), gleiches Ubuntu 24.04, shell-Executor, kein Container.
   Die echte Ursache lag im Testcode (ein leeres Messfenster) und ist behoben — der Job ist
   gruen. **Es ist keine Cluster-Aenderung noetig.**
2. **`cache_misses_l3_ll` liefert auf prod1 nichts** — `errno=2 (No such file or directory)`.
   Der Zaehler existiert dort in dieser Kodierung nicht. Das ist eine Code-Frage
   (RAW-Events je Mikroarchitektur), keine Maschinen-Frage.

**Zur Kenntnis, ohne Handlungsbedarf:** prod2 ist ein i9-12900K (Alder Lake, Hybrid: P-Cores +
E-Cores mit getrennten PMU-Domaenen `cpu_core`/`cpu_atom`). Das ist **so gewollt** — die
Hybrid-Plattform steht seit dem Scope-Freeze vom 12.04.2026 in der Forschungsfrage. Die
Diplomarbeitslinie baut die getrennte Messung selbst.

---

## Zugangs-Hinweise (keine Werte)

- **PAT:** Kandidaten blind aus `Cluster/keys/CREDENTIALS-VAULT-{DEV,PROD}.md` extrahieren und
  **rueckwaerts** gegen `GET /api/v4/user` testen, bis HTTP 200. **Die Position rotiert — nie
  hartcodieren.** Fehlversuche sind harmlos. Heute traf Kandidat 7 von 8.
- **CA:** `Cluster/keys/gitlab-ca-ROOTCA-20260621.crt`
- **Host:** `gitlab.comdare.local` (die `.de`-Adresse ist abgeschaltet)
- **Projekt-IDs:** ce 286 · super 288 · thesis 289
- Token-Werte **nie** in Dateien, Berichte oder Commit-Nachrichten. Fuer `curl` eine
  0600-Config mit `-K` verwenden und sie danach shreddern.

---

## Zusammenfassung fuer die Uebergabe

| # | Posten | Schwere | Braucht |
|---|---|---|---|
| P-1 | 390 Runner-Token nicht rotiert (286/288/289 verifiziert) | **hoch** | Cluster-Schreibrecht |
| P-2 | gitleaks-Submodul-Aufruf meldet still gruen | mittel | Skript mit Nenner-Abbruch |
| P-3 | `xmllint` auf den Runnern unbelegt (O-D) | mittel | Host-Pruefung, ggf. Installation |
| P-4 | Runner-Zahlen OD-7, Soll/Ist unklar + Tag-Falle | mittel | Live-Verifikation |
| P-5 | Platz und `df`-Wache vor dem Voll-Bau | mittel | vor dem naechsten Voll-Bau |

Rueckfragen an die Diplomarbeitslinie jederzeit; die Messkette selbst bleibt dort.
