# KONTEXTÜBERGABE 07.08.2026 spätabends — zwölf Landungen, sechs Entscheide, NEUN neue Aufträge

**ERST-ANKER.** Der Kontext endete hier. Dieses Dokument trägt alles, was der Wiederanlauf braucht.

> **LESE-REIHENFOLGE**
> 1. Dieses Dokument, Abschnitt **3** (die neun frischen Owner-Aufträge — das ist die Arbeit)
> 2. `docs/sessions/20260807-ZWISCHENSTAND-elf-landungen-und-die-offenen-fragen.md`
> 3. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Nachträge **abend-1 … abend-23**
> 4. `docs/plaene/20260807-VORLAGE-lizenzwahl-drei-repos.md` · `docs/sessions/20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md`

---

## 1. REFS

| Repo | Ref |
|---|---|
| **ce** `development` | **`fea430d0`** (cppcheck-Heilung) |
| **super** `development` | **`aa32b427`** |
| thesis | `eaf7fe8` — **darf jetzt angefasst werden** (Owner-Freigabe, s. Auftrag 4) |
| ce `bau/ee-overlay-glied` | **im Bau, 2 Änderungen im Arbeitsbaum** — E-E |

**Platz: nur noch ~5 GB frei.** Build-Bäume der fertigen Stränge tragen je eine **getrackte**
Messdaten-CSV — sie sind über git wiederherstellbar, aber die Messdaten-Regel gilt.

---

## 2. WAS HEUTE GELANDET IST — zwölf Pakete

Flag-Grammatik v2 (`5060489e`) · allocators-Gate (`5adf59ea`) · M-3a `branch_misses` (`6a8ab995`) ·
Restposten + Wachen-Fix (`5aad9c43`) · S2-Katalogwache (`5788dc12`) · A9-S1 xlsx-Vendor (`351205f5`) ·
A5/ETA (`73f9a56f`) · FK-3/FK-4 (`f2709599`) · cppcheck-Heilung (`fea430d0`) ·
175 stale Doku-Anker · §55-Reconcile (43 Meldungen = **36** Posten) · STOPP-Gates-Vorlage.

**Drei Wachen repariert**, die ihren eigenen Vertrag brachen. **Die letzte Heilung:** `lint:static`
war rot — cppcheck fährt mehrere Präprozessor-Konfigurationen und probierte die Annahme, das
Boost-Makro sei gesetzt. Der Bau war immer grün (424/424). Gelöst über das Haus-Muster
`cppcheck-suppress` **mit Begründung**; **die Wache bleibt für den Compiler scharf.**

---

## 3. DIE NEUN FRISCHEN OWNER-AUFTRÄGE — das ist die offene Arbeit

### A1 · MMX/3DNow: Webrecherche, dann Basis-Entscheid
> *„MMX ist formal eine eigene Hardware und 3dnow auch oder irre ich mich? Bitte webrecherche dazu.
> **Gehört es zusammen → eigene Basis; gehört es separat → bloßes Token.** Zum Beispiel ist AVX512 ein
> konzeptioneller Block, aber hat verschiedene zusammenhängende register-Erweiterungen."*

**Das Kriterium ist damit gegeben** — es geht um die Frage, ob MMX und 3DNow **einen gemeinsamen
Registersatz mit zusammenhängender Verarbeitung** bilden (→ Basis `x64{…}`) oder unabhängige
Einzelerweiterungen sind (→ Token auf Tiefe 0). **Sechs Zeilen sind in
`flag_grammar_catalog.hpp` `static_assert`-markiert** (`flag_catalog_offene_entscheide() == 6`).

### A2 · System-Permutationen für prod1 UND prod2 durchrechnen — große Simulationsaufgabe
> *„Bitte rechne durch, welche System-Permutationen jetzt auf beiden Maschinen möglich werden […]
> Bitte erkenne, dass die **XML konfigurierten Achsen von den in den Papern vorgeschlagenen
> Algorithmen abhängen**, sodass wir uns je Bau+Messung (**mindestens compare Modus**) auf die
> **Simulation von allen Papern gegeneinander** konzentrieren können, was die Möglichkeiten real
> gebauter und gemessener Binaries **extrem einschränkt**. Bitte **code review**, was die aktuelle
> Konfiguration aller Paper für Vergleichs-Permutationen über alle Achsen erzeugen müsste und dann
> **errechnest du die Zahlen**."*

**Das ist die Antwort auf die offene Bau-Mengen-Frage (D-2)** — nicht durch Setzung, sondern durch
Rechnung. Ausgangsdaten: `all_axes_golden.profile.xml` deklariert heute **vier** System-Perms;
`FullSourceCatalog` = 2^17 je System-Perm; **prod1 = AMD Ryzen 9 9950X3D, nicht hybrid, aber
L3-asymmetrisch (16×32 MB / 16×96 MB)**; prod2 derzeit **nicht auflösbar** (Infra #207).

### A3 · ETA-System: Verständnis-Gespräch
> *„Wir sollten darüber chatten, dein Verständnis dazu ist der Schlüssel. **Wie verstehst du derzeit
> das ETA System in der Lagerhaltung?**"*
**Kein Bau — ein Gespräch.** Grundlage: der A5-Bau von heute (`73f9a56f`), besonders der Befund, dass
`merge_documents` **jede zweite Fortschreibung still verwirft**, und die Umstellung des
Takeover-Fensters von pauschal 30 min auf `1,5 × ETA`.

### A4 · Thesis nachziehen — FREIGABE ERTEILT
> *„Ja bitte zieh sie gegen den neueren Code nach, **deutsch führt und englisch wird nachgezogen als
> Übersetzung**."*
Betrifft: die **Stolperstelle** („achtzehn Achsen … 2^17" — rechnerisch richtig, weil
`persistence_target` gepinnt ist; ein Prüfer rechnet 2^18) und die **Lizenz-/PMC-Aussagen**.
**Thesis-Commits ohne `Co-Authored-By`-Trailer** (Hausregel).

### A5 · E-B: die Erst-Klammerung suchen — Explore über FÜNF Wochen
> *„Es gab **verbatim im Session log** dazu eine Beschreibung der **Erst-Klammerung von Mess-Achse,
> System-Achse und Organ-Achse** von mir, bitte durchsuche die letzten **5 Wochen** mit Explore.
> **Suche nach Filesystem Lagerhaltung der Binaries.**"*
Der erste Explore fand sie **nicht** (er suchte „Lagerhaltung", nicht „Erst-Klammerung"). **Neue
Suchbegriffe: Erst-Klammerung · Klammerung · Filesystem-Lagerhaltung · die drei Achsen-Kategorien
zusammen.** Suchorte: `docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-*.txt` —
dort liegen die **982 Owner-Records verbatim**, dort wurde auch der Overlay-Ursprung gefunden.

### A6 · NAS: beide Hosts sind gesund
> *„backup1.comdare.de und backup2.comdare.local sind beide **gesund, wohlauf und reaktiviert**. Wir
> verwenden für cluster prod das **backup1**."*
**Der Skript-Kommentar in `scripts/copy_results_to_nas.sh:4` ist damit überholt** (er führt den Host
als abgeschaltet). **Nachzuziehen.**

### A7 · Kapazität: 16 TB frei, Größe unkritisch
> *„Ich habe von 7,5TB einfach grob aufgerundet — wir haben **16TB auf dem NAS frei**, mich
> interessiert die Größe wenig."*

### A8 · Infra selbst beheben — AUSDRÜCKLICHE AUSNAHME
> *„Bitte **behebe dieses infra Problem selbst als Ausnahme**. Wir sollten **Lesen und schreiben**
> können! Bitte **lies in infra die VLAN Tabelle** um das System zu verstehen und **lesen
> freizuschalten**."*
**Das hebt die Cluster-read-only-Regel für DIESEN Fall auf.** Heute: V60-Runner dürfen `Cluster_NFS`
**nie lesen**, nur schreiben über einen Filterpod (`PUT https://measure-drop.comdare.local/…`,
Backend `nfsvers=3`). **Zuerst die VLAN-Tabelle lesen** (`reference_cluster_vlan_tabelle_sni_standard_pattern`),
dann das Lesen freischalten. **Vorsicht: das ist ein echter Infra-Eingriff.**

### A9 · Scharfer Code-Review auf `std::variant` und Laufzeitumwege
> *„Um **binary bloat und jitter in Latenz-kritischen Messungen** im Feld der Forschung von
> Datenbanken auszuschließen MUSS std::variant und **Laufzeitumwege** ausgeschlossen werden wo es nur
> geht → **sehr scharfer code review auf allen Klassen und Organen und Interfaces** notwendig."*
**Damit ist Frage 9 beantwortet: das Verbot bleibt, und es wird verschärft.** Der Grund ist jetzt
**Jitter**, nicht Speicher. Ausgangslage: 68 `variant`-Treffer geprüft, kein Verstoß — aber der
Review soll **weiter gehen**: `virtual`, `std::function`, Indirektionen, alles was im Hot-Path
verzweigt. Die erlaubte vtable-Zone ist heute die ABI-Grenze (`IAnatomyBase`/`IDriveableTier`/
`IMeasurableWorkload`).

---

## 4. DIE ENTSCHIEDENEN STEMPEL-GATES

| Id | Entscheid |
|---|---|
| **E-A** | **SHA-256, 64 Hex** — passt unter `kStemMax = 120`. **Der Name ist KEIN Präfix des Fingerprints** (der bleibt SHA-512), sondern ein eigener Hash über dasselbe Preimage |
| **E-B** | **(i)** — Emitter schreibt den Namen, **golden-CRC bricht**. Begründung ist eine **Owner-Setzung**, im Code nicht auffindbar (s. A5) |
| **E-C** | Sidecars **mitziehen** |
| **E-D** | Ordnernamen auf den Stempel, Doppelspalte im Übergang |
| **E-E** | Konkatenation · feste Ordnung je Achsen-Kategorie · Schnitt über die **drei kanonischen Achsen-Ordnungen + `anatomy/`** — **im Bau** |
| **E-F** | **honest-empty** |
| **Ω-1/2/3** | Resolver generisch · CSV mit **Provenienz-Spalte** · L3-Achse scharf |

---

## 5. WAS BEIM OWNER BLEIBT

- **Lizenz:** die Thesis sagt **gedruckt** Apache-2.0 für super und PRT-ART. Der Wunsch (alle drei
  restriktiv) **widerspricht dem Sperrvermerk** — entweder Thesis nachziehen oder nur ce restriktiv.
  Empfehlung: **PolyForm Noncommercial 1.0.0** + Einzelvertrag. **Zwei Voraussetzungen sind
  ungeklärt und anwaltlich/administrativ:** ob die Rechte tatsächlich bei der UG liegen (das
  Urheberrecht entsteht beim Prüfling **persönlich**), und ob die Prüfungsordnung Veröffentlichung
  verlangt.
- **Merge-Konfliktauflösung** (ETA): geänderte Auflösung oder monotones Ordnungsfeld?
- **Drei Lizenz-Abweichungen** + `liburing` fehlt in beiden Lizenzdateien.

---

## 6. WICHTIGE FALLEN DES TAGES

- **`grep` ohne `-w`**: `ESET` = 26 Treffer, `-w ESET` = **0**
- **Zwei-Punkt- statt Drei-Punkt-Diff**: misst den **Rückstand**, nicht die Arbeit
- **`EXCLUDE_FROM_ALL`-Generatoren**: vier Roundtrip-Tests laufen **falsch rot** — erst
  `comdare_*_registry_gen` + `test_profile_roundtrip` explizit bauen
- **Eine untrackte Datei zeigt `git diff` nicht** — Bissproben nur mit getrackten Änderungen
- **Zwei Dokumente sind stale und führen in die Irre:** der Versionierungs-Plan zitiert **viermal**
  einen überholten golden-CRC und rechnet mit Format 3 statt 4

**Meine drei eigenen Fehlerklassen (Memory 7–9):** committen während der eigenen Prüfung ·
`git add -A` neben einem Agenten · **eine Basis-SHA im Auftragstext**, die übernommen statt erhoben
wurde.

**Achtmal war eine Auftragsprämisse von mir falsch, achtmal hat ein Agent am Objekt widersprochen.**
Gemeinsamer Nenner: **eine Abwesenheit wurde als Aussage genommen.**
