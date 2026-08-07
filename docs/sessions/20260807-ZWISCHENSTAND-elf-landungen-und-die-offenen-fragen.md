# ZWISCHENSTAND 07.08.2026 abends — elf Landungen, sechs Entscheide, neun offene Fragen

**ERST-ANKER.** Dieses Dokument trägt den vollen Stand: was gelandet ist, was entschieden wurde,
was noch läuft, und **die neun Fragen, die nicht eindeutig beantwortet sind**.

---

## 1. REFS

| Repo | Ref | Stand |
|---|---|---|
| **ce** `development` | `f2709599` | Pipelines grün |
| **super** `development` | `d2b6f3fd` | grün |
| thesis | `eaf7fe8` | unberührt |
| ce `bau/ee-overlay-glied` | im Bau | E-E, läuft |

---

## 2. WAS HEUTE GELANDET IST — elf Pakete

| Paket | Ref | Was den Beleg trägt |
|---|---|---|
| Flag-Grammatik v2 | ce `5060489e` | acht Regeln compile-time bewiesen; der Agent fand eine Lücke in seinem **eigenen** ersten Commit |
| allocators-Abdeckungs-Gate | ce `5adf59ea` | 7 Bissproben; eine deckte eine Falschaussage im eigenen Kommentar auf |
| M-3a `branch_misses` | ce `6a8ab995` | Last **validiert**: 704 Misses beim ersten Entwurf, 8,4 Mio. beim richtigen |
| Restposten + Wachen-Fix | ce `5aad9c43` | die Wache maß den **Rückstand**, nicht die Arbeit |
| S2-Katalogwache | ce `5788dc12` | 104 `static_assert`s, 15 Bissproben; die Struktur wurde vom Katalog **erzwungen** |
| A9-S1 xlsx-Vendor | ce `351205f5` | 37 MB → 1,9 MB; Rauchtest liest die Zelle **zurück** |
| A5/ETA-Kalibrierung | ce `73f9a56f` | ein Merge gefunden, der **still verwirft** |
| FK-3/FK-4 Fehlerklassen | ce `f2709599` | 8 Bissproben; `{Failed}` geraten und **am Code korrigiert** |
| 175 stale Doku-Anker | super | 17 Dokumente geheilt |
| §55-Reconcile | super | 43 Meldungen sind **36** Posten |
| STOPP-Gates-Vorlage | super | 537 Zeilen, alle sechs inzwischen entschieden |

**Drei Wachen repariert**, die ihren eigenen Vertrag brachen: Zwei-Punkt- statt Drei-Punkt-Diff ·
Hygiene-Wache griff **Fremdcode** · eine Wache schlug richtig an und **berichtete falsch**.

---

## 3. DIE ENTSCHEIDE VON HEUTE ABEND

| Id | Entscheid |
|---|---|
| **E-A** | **SHA-256, 64 Hex** — passt unter `kStemMax = 120` |
| **E-B** | **(i)** — Emitter schreibt den Namen, **golden-CRC bricht** |
| **E-C** | Sidecars **mitziehen** |
| **E-D** | Ordnernamen auf den Stempel, Doppelspalte im Übergang |
| **E-E** | Konkatenation · feste Ordnung je Achsen-Kategorie · Schnitt über die **drei kanonischen Achsen-Ordnungen + `anatomy/`** |
| **E-F** | **honest-empty** |
| **Ω-1/2/3** | Resolver generisch · CSV mit **Provenienz-Spalte** · L3-Achse scharf |

**Zwei Präzisierungen, die beim Bau zählen:**
- **E-A:** der Name ist **kein Präfix** des Fingerprints (der bleibt SHA-512), sondern ein **eigener
  Hash über dasselbe Preimage**. Wer `name == fingerprint[0:64]` annimmt, irrt.
- **E-B:** der Explore konnte die Lagerhaltungs-Begründung **nicht finden**. Der Bau folgt der
  Owner-Setzung, aber der Kommentar wird sagen, dass sie eine **Setzung** ist.

---

## 4. DIE NEUN OFFENEN FRAGEN

### 🔴 Q1 · MMX-Basis — eine Aussage über die Hardware
MMX/3DNow liegen auf **x87-aliasierten** Registern. Die Grammatik trägt **beide** Gestalten: bloßes
Top-Level-Token (`1.0.0.c.mmx.3dnow`) **oder** eigene Basis (`1.0.0.c.x64{mmx.3dnow}`).
**Sechs Zeilen sind `static_assert`-markiert**, wer entscheidet, kommt an ihnen nicht vorbei.
**Warum ich nicht rate:** der falsche Schnitt stünde danach in **jedem Fingerprint-Preimage**.
Nicht offen ist dagegen: die Familie steht unter **keiner** der drei Breiten-Basen — `x128{mmx}` bricht.

### 🔴 Q2 · Bau-Menge (D-2) — vier Kandidaten, Faktor 16
131.072 / 524.288 / 1.572.864 / 2.097.152. Der Ist-Stand: das Golden-XML deklariert **vier**
System-Perms → real **524.288**. Die 12-Perm-Doktrin und der line_size-Faktor sind **nicht**
nachgezogen. **Fällig vor der Voll-Messung, nicht vor dem ersten Batch.**

### 🔴 Q3 · Merge-Konfliktauflösung (aus dem ETA-Bau)
`merge_documents(remote{eta=100}, lokal{eta=250})` liefert **100** — bei gleichem Rang gewinnt
stabil das Remote. **Jede zweite Fortschreibung wird verworfen, während `store()` `true` meldet.**
Zwei Wege: **geänderte Konfliktauflösung** oder ein **monotones Ordnungsfeld**. Beides berührt Draht
und Semantik. Ein Test nagelt das heutige Verhalten fest — **schlägt er fehl, ist die Fortschreibung
frei.**

### 🔴 Q4 · Darf ich die Thesis anfassen?
Zwei Stellen wären betroffen: die **Stolperstelle** („achtzehn Achsen … 2^17" — rechnerisch richtig,
weil eine Achse gepinnt ist, aber ein Prüfer rechnet 2^18) und die **Lizenz-Tabelle**.
Sie ist deine persönliche Prüfungsleistung. **Ohne ausdrückliches Wort bleibt sie unberührt** — auch
unter einer Pauschalfreigabe.

### 🟡 Q5 · E-B: welche Lagerhaltungs-Operation braucht den Symbol-Namen?
Nicht als Rückfrage an die Entscheidung — **für den Kommentar an der Stelle**. Der Explore fand
vierfach belegt: die Lagerhaltung identifiziert über `key_sha512` aus dem **Sidecar**, nicht über die
Symboltabelle. **Ein Satz genügt**, sonst entsteht eine Wache, die später niemand begründen kann.

### 🟡 Q6 · NAS: der Host-Widerspruch
Du nanntest `backup1.comdare.de`. Das Skript dort führt genau diesen Host als **abgeschaltet**
(`.de → .local`). **Geprüft: `.de` löst auf, `.local` nicht.** Entweder ist der Kommentar veraltet
oder die Umstellung wurde zurückgenommen. **Vor jeder Ablage zu klären.**

### 🟡 Q7 · NAS: die 8 TB sind nirgends belegt
Kein gefundenes Dokument nennt eine Kapazität für backup1/PR4100. Die dokumentierten **6 TB** gehören
zu einem **anderen** Ziel (`prod-longhorn`-Coldstore).

### 🟡 Q8 · NAS: Runner dürfen nicht lesen
`Cluster_NFS` ist für V60-Runner **schreib-only**, über einen Filterpod per
`PUT https://measure-drop.comdare.local/<ts>/<datei>`. **Ein Mount ist nicht der geplante Weg.**
Dazu ein **ungelöster Transport-Widerspruch** in der Planung selbst: Design will POSIX-Mount-Copy,
die Infra nutzt HTTPS-PUT.

### 🟡 Q9 · Bleibt das `std::variant`-Verbot?
Du sagtest, der Speicher sei kein Problem. **Ich lese das als „kein Blocker für den Bau", nicht als
„das Verbot fällt"** — die Direktive nennt zwei weitere Gründe: *„Kein Runtime-Tag, kein
`std::visit`"* und *„der Compile muss REIN sein: KEINE runtime→CT-Brücken"*.
**Praktisch ändert es nichts:** der Bau ist ohne Bloat, also 256–640 GB statt 7,5 TB.

---

## 5. WAS LÄUFT

| Vorgang | Zustand |
|---|---|
| **E-E-Overlay-Bau** | läuft — Codegen, vier Anker, drei Bissbeweise |
| **Lizenz-Recherche** | läuft — Optionen für die drei Repos |

---

## 6. DIE LEHREN DES TAGES

**Achtmal war meine Auftragsprämisse falsch, achtmal hat ein Agent am Objekt widersprochen.**
„nicht verdrahtet" · „vergessen" · „tot" · „fehlt in der Liste" · „`hybrid_core_aware` setzen" ·
„hat keinen Aufrufer" · „`topics/*/axis_*` genügt" · „`aes` ist ein Companion".
**Gemeinsamer Nenner: eine Abwesenheit wurde als Aussage genommen.** Die Regel steht jetzt in jedem
Auftrag: *„X fehlt" ist ein Nullbefund, bis die Gegenprobe gefahren ist.*

**Drei Fehler lagen in meiner Arbeitsweise** (Memory-Klassen 7–9):
- committen, **während die eigene Prüfung noch läuft**
- `git add -A` **neben einem arbeitenden Agenten**
- eine **Basis-SHA im Auftragstext**, die übernommen statt erhoben wurde

**Sieben neue Fallen im Register**, darunter: `grep 'ESET'` = 26 Treffer, `grep -w 'ESET'` = **0**.

---

## 7. WIEDERANLAUF

1. Dieses Dokument, Abschnitt 4 (**die neun Fragen**)
2. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Nachträge **abend-1 bis abend-23**
3. `docs/sessions/20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md` — die Entscheide im Volltext
4. `docs/sessions/20260807-RECONCILE-43-positionen-disposition.md` — 36 Posten, sieben Duplikate

**Zwei Dokumente sind nachweislich stale und führen Leser in die Irre:** der Versionierungs-Plan
zitiert **viermal** einen überholten golden-CRC und rechnet mit Format 3 statt 4.
