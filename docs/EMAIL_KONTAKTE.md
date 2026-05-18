# EMAIL_KONTAKTE — Reply-Status der 5 Autor-Anfragen (REV 3)

**Stand:** 2026-05-18 (L.5)
**Vorgaenger-REV:** REV 2 (PHASE 5 LESSON-LEARNED, 2026-05-08) — nicht persistiert als separate Datei, aber in Memory + Sessions verankert.
**User-Direktive 2026-05-18:** "Mehr Nachrichten werden wir nicht erhalten."

---

## §1 Uebersicht der 5 Anfragen

| Paper | Empfaenger | Verschickt | Status REV 3 | Code-Stand |
|---|---|---|---|---|
| **P06** | Maximilian E. Schuele (Uni Bamberg, +Habich Cc) | 2026-05-07 + 2026-05-08 | ✅ **ANTWORT 2026-05-08 23:37** (2 Nextcloud-Links) | voll, in `Forschungsarbeiten/code/P06-B2tree/{b2-tree-master, bart-master}/` |
| **P27** | Tingji Zhang (Tsinghua, via Boris Grot Edinburgh, +Habich Cc, +zyh02 Cc) | 2026-05-08 18:59 | ✅ **ANTWORT 2026-05-11 14:16** (hp-soft.zip Demo-Paket) | hp_soft.py + readme.txt in `Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/hp-soft/` |
| **P28** | Roland Kuehn (TU Dortmund DBIS, +Habich Cc) | 2026-05-07 02:45 + 2026-05-08 17:48 | ✅ **ANTWORT 2026-05-08 10:35** (Code zugesagt + Aufraeumen vorher) | noch nicht eingegangen, aber zugesagt |
| **P31** | Habich-Team (Ungethuem 2017) | (intern via Habich-Sprechstunde) | ⏸ **KEINE FORMAL-MAIL** — User-Direktive 2026-05-18: keine Folge-Mails | im Cluster F via Habich-Tier-3 dokumentiert |
| **P32** | Habich-Team (Schmidt 2025) | (intern via Habich-Sprechstunde) | ⏸ **KEINE FORMAL-MAIL** | im Cluster F dokumentiert |
| **P33** | Habich-Team (VAMPIR Poster 2023) | (intern via Habich-Sprechstunde) | ⏸ **KEINE FORMAL-MAIL** | im Cluster F dokumentiert |

**3 von 5 Antworten erhalten** (P06, P27, P28). P31/P32/P33 sind Habich-intern und keine Mails erwartet.

---

## §2 P06 Schuele — Voller Quellcode

**Verschickt:** 2026-05-07 10:32 (Erstmail) + 2026-05-08 01:09 (Folgemail Postfach-voll-Problem)

**Antwort 2026-05-08 23:37:22:**

```
Von: Maximilian E. Schuele <maximilian.schuele@uni-bamberg.de>
An: Probst, Benjamin-Elias
Cc: Habich, Dirk

https://nextcloud.in.tum.de/index.php/s/xXEw2SGfGeWNfjA
https://nextcloud.in.tum.de/index.php/s/63M9YqazFQDS2TR

Viele Gruesse / Best regards
Maximilian E. (Schuele)
```

**User-Antwort 2026-05-13 23:35:** "Dankeschoen, das hat geklappt"

**Vorgeschichte (aus Mail-Kette):**
- B²-Tree-Code lag urspruenglich in `https://gitlab.db.in.tum.de/MaxEmanuel/bart` (privat)
- bart-master basiert auf Viktors B-ART (privat, "wo er den Quellcode nicht oeffentlich sehen moechte")
- Schuele bot github-Hinzufuegung an, dann via Nextcloud transferiert

**Code-Drops:**
- `Forschungsarbeiten/code/P06-B2tree/b2-tree-master/` (voller B²-Tree-Source)
- `Forschungsarbeiten/code/P06-B2tree/bart-master/` (Cross-Algorithm-Vergleichsbasis)

**STATUS-Doku:** `Forschungsarbeiten/code/P06-B2tree/STATUS.md` (REV vom 2026-05-08 + L.2-Append 2026-05-18)

---

## §3 P27 Zhang/Grot — hp-soft Demo-Paket

**Verschickt:** 2026-05-08 18:59 (an zyh02@tsinghua + Boris.Grot@ed.ac.uk, +Habich Cc, +zyh02 Cc)

**Boris Grot Weiterleitung 2026-05-10 21:36** an Tingji Zhang.

**Tingji Zhang Antwort 2026-05-11 14:16:38:**

```
Von: ztj22 <ztj22@mails.tsinghua.edu.cn>
An: Probst, Benjamin-Elias
Cc: Habich, Dirk; zyh02@tsinghua.edu.cn; Boris Grot

Thank you for your interest in our work and for your kind words.
I am attaching a small demo package that may help with your implementation.
The zip file contains a Python script and a README.
It provides an example processing script explaining the call graph analysis
process used in Hierarchical Prefetching.
It should capture the core bundle-selection logic and hopefully serve as
a useful reference for adapting the idea to your PRT-ART implementation.
Please feel free to let us know if anything is unclear.

Best regards,
Tingji
```

**User-Antwort 2026-05-13 23:37:** "Dear Tingji, Thank you, that helped me a lot!"

**Code-Drop:**
- `Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/hp-soft/hp_soft.py` (3751 B)
- `Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/hp-soft/readme.txt` (436 B)

**License:** **CC-BY** (open access via Edinburgh Research Explorer), DOI 10.1145/3676641.3716260

**V31-Integration:**
- ✅ V31.K5: C++23-Port als `comdare-prt-art/tools/p27_bundle_finder/`
- ✅ V31.K6: Runtime-Reimpl als `comdare-prt-art/prt_art/include/prt_art/prefetch/hierarchical_bundle_prefetcher.hpp`
- ⏳ Adapter pending: `Code/external/comdare-cache-engine/adapters/P27-hp-soft/`

**User-Memory-Direktive (Zhang):** "Herr Zhang ist ein sehr stolzer und zynischer Mensch. Mehr als dieses Sammelsurium aus Hinweisen werden wir nicht bekommen." Damit ist P27 abgeschlossen.

**STATUS-Doku:** `Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/STATUS.md` (REV vom 2026-05-14 + L.3-Append 2026-05-18)

---

## §4 P28 Kuehn — Code zugesagt, ausstehend

**Verschickt:** 2026-05-07 02:45 (Erstmail) + 2026-05-08 17:48 (Folgemail mit Plattform-Info + Postfach-15MB)

**Antwort 2026-05-08 10:35:47:**

```
Von: Roland Kuehn <roland.kuehn@tu-dortmund.de>
An: Probst, Benjamin-Elias

Hallo Benjamin-Elias,

ich hoffe, es ist okay, wenn wir uns duzen :). Das Thema deiner Diplomarbeit klingt
auf jeden Fall spannend und passt thematisch sehr gut zu den offenen Fragen aus
unserem Paper. [...]

Ich denke, dass wir euch den Code grundsaetzlich zukommen lassen koennen. Ich muss
allerdings dazu sagen, dass es sich dabei eher um experimentellen Evaluationscode
als um ein sauber gekapseltes Framework handelt. Ich muesste daher zumindest noch
einmal den Code durchgehen und alles ein wenig aufraeumen und dokumentieren ;)

Beste Gruesse nach Dresden
Roland
```

**Wichtige Erkenntnisse aus Kuehn-Mail (Telemetry-Strategie):**

| Strategie | Beschreibung | Kuehn-Status |
|---|---|---|
| **Leaf-Only-Counter** | Counter NUR in Blatt-Knoten | **Hauptvariante 2024+** (Achse 11.X1) |
| **Sampling** | jeder n-te Zugriff im Blatt-Knoten | erweitert (Achse 11.X2) |
| **Offline-Recompute** | bottom-up Aufsummierung vor Reordering | Standard-Verfahren (Achse 11.X3) |
| **Inner-Node-Counter** | Counter in ALLEN Knoten | **ANTI-PATTERN** (Cache-Line-Ping-Pong, Achse 11.X4) |

**Code-Status 2026-05-18:** noch nicht eingegangen, aber zugesagt. User-Direktive: keine weiteren Mails.

**STATUS-Doku:** `Forschungsarbeiten/code/P28-Kuehn-DAMON/STATUS.md` (REV vom 2026-05-08 + L.1-Append 2026-05-18)

---

## §5 P31/P32/P33 — Habich-Tier-3 (intern, keine Formal-Mails)

| Paper | Autor | Quelle |
|---|---|---|
| P31 | Ungethuem/Habich et al. 2017 | Overview Hardware Optimizations for Trie-Based Indexes |
| P32 | Schmidt/Habich et al. 2025 | To Stride or Not to Stride |
| P33 | Berthold/Habich et al. 2023 | VAMPIR Poster (SOSP'23) |

Diese 3 Tier-3-Paper sind direkt in der Habich-Forschungslinie. Habich-Sprechstunde 2026-05-08 hat die Architektur-Direktiven dazu festgelegt. Keine Formal-Mails erforderlich.

**STATUS:** dokumentiert in `docs/forschungslandkarte/07_cluster_F_sync_tud_habich.md` (Cluster F).

---

## §6 Konsolidierungs-Status

| Konsolidiert in | Stand |
|---|---|
| `docs/bausteine/01_bausteine_matrix.md` §16 + `07_bausteine_matrix_N_erweitert.md` | DONE (N-Phase 2026-05-18, Kuehn 11.X1-X4 verankert) |
| `docs/forschungslandkarte/06_cluster_E_prefetching_telemetry.md` (P27 + P28) | DONE (K-F.7, 2026-05-15) |
| `Forschungsarbeiten/code/P*/STATUS.md` | DONE (L-Phase 2026-05-18) |
| `~/.claude/.../memory/reference_email_status.md` | DONE (L.6 2026-05-18) |
| `~/.claude/.../memory/reference_p27_zhang_no_more_input.md` | DONE (vorher 2026-05-14) |

---

## §7 Querverweise

- E-Mail-Verlaeufe (PDFs am Top-Level):
  - `../E-Mail Kühn – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`
  - `../E-Mail Schüle – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`
  - `../E-Mail Zhang – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`
- Session 4800 (Email-Auswertung + Vermischungs-Analyse): `sessions/20260518-4800-mail-auswertung-drawio-feedback-vermischungen-M-N-O-P-Q-R-phasen.md`
- Bausteine N-Phase: `bausteine/07_bausteine_matrix_N_erweitert.md`
- Forschungslandkarte Cluster E (P27 + P28): `forschungslandkarte/06_cluster_E_prefetching_telemetry.md`
- Forschungslandkarte Cluster F (P31/P32/P33): `forschungslandkarte/07_cluster_F_sync_tud_habich.md`
- Memory Email-Status: `~/.claude/.../memory/reference_email_status.md`
- Memory P27 Zhang: `~/.claude/.../memory/reference_p27_zhang_no_more_input.md`

---

**Ende docs/EMAIL_KONTAKTE.md REV 3 (L.5 DONE).**
