# KONTEXTUEBERGABE 11.08.2026 — der Tag, an dem die Riegel zurueckschlugen

> **Stand bei Uebergabe:** super `43ddfec7` · ce `31240ac5` · Projekte `c62c888` — alle synchron
> auf GitLab und GitHub. Platte 26 G frei. 8 Worktrees. **F1 ist Freitag 14.08. — drei Tage.**

---

## 0. DER EINE SATZ, MIT DEM DIE NAECHSTE SESSION ANFAENGT

**Die F1-Lieferung fehlt.** Der Tag hat viel verhindert und wenig geliefert; die Planabgrenzung
sagt es woertlich:

> *„der Workflow war ueberwiegend Verhinderung und Korrektur (wertvoll, aber nicht die
> F1-Lieferung)"*

**Zehn Plan-Forderungen fuer F1 haben kein Paket.** Die schwerste ist `##25 DURCHSTICH` — der am
Mittwoch frisch gemessene Mini-Messwert, der am Freitag als Tabellenzeile im Thesis-Submodul
stehen soll. Sein letzter benannter Blocker ist laengst entschaerft (#76: der „Stempel-Riss" war
Sollverhalten). **Die Abnahme existiert trotzdem nicht.** Damit fehlt am Freitag der Traeger des
Abgabefaehigkeits-Minimums.

**Erster Griff:** `docs/sessions/20260811-PLANABGRENZUNG-UND-CODEX-VOLLREVIEW.md` lesen,
Abschnitt 4 (F1-Luecke mit Postenliste). Dann `##25` schneiden und bauen.

---

## 1. WAS HEUTE GELANDET IST

| SHA | Repo | Inhalt |
|---|---|---|
| `f528a4c7` | ce | **Stage-Topologie** — `test` vor `contract`, zweite needs-Kante, dritte Achse der Abdeckungs-Wache scharf (17/0 → 18/0 Kanten) |
| `f610e05d` | ce | clang-format, 52 → 0 Verstoesse ueber 1857 Dateien |
| `68fbd930` | ce | **Klasse (k)** in `algo_semver.hpp` + Stage-Wache im T-6-Inventar |
| `4440bc87` | ce | clang-format der P-GLIED-Dateien, 21 → 0 |
| `31240ac5` | ce | **P-GLIED**: GLIED [6] Teilmenge statt Gleichheit, Sidecar v2, `-Wshadow`-Fix |
| `afa5815a` | super | **`GUARD_BASIS_REF` literal** + Guard-Basis-Bissprobe (485 Z., 5 Arme) + `test:guard-basis-probe` |
| `5837ff7f` | super | Ergebnis des nachgeholten Dual-Reviews (410 Z.) |
| `43ddfec7` | super | Ergebnis der Planabgrenzung + Codex-Vollreview (252 Z.) |
| `c62c888` | **Projekte** | **Arbeitsweise v3.2** — A2.1 „parallel bauen, sequentiell landen" |

---

## 2. 🔴 WAS SOFORT ANSTEHT

### (a) `test:coverage-guard` ist DETERMINISTISCH ROT — Posten #80

**Zweimal am lebenden Objekt belegt** (Pipelines 15667 und 15669, je `exit 4`). Ursache sind
**zwei** Dinge, die sich addieren:

    URSACHE 1  ce/.gitlab-ci.yml:511-512  build-covguard MIT -DCOMDARE_CE_PRUEFLINGE
               ce/.gitlab-ci.yml:978      test:unit     OHNE den Schalter
               :507-508 sagt WOERTLICH, dass diese Gegenrichtung BEWUSSTE T-4-Deckung ist
               -> 1 Test Differenz, auf JEDEM Host, in JEDER Pipeline

    URSACHE 2  test:unit landete auf prod2 (ohne AVX-512, 478 Tests)
               coverage-guard auf prod1 (mit AVX-512, 483)
               -> 4 weitere, exakt die Menge aus Fussnote D2-G5

**Der Owner hat Ursache 2 eingeordnet:** prod2 kann AVX-512 nicht testen und registriert
compile-time weniger Tests — daran ist nichts falsch. **Die Wache ist an dieser Stelle zu
streng.** Sie ist zu praezisieren, nicht abzuschalten: deklarierter SOLL-DELTA plus Host-Klasse.

**Die Reihenfolge ist bindend: F1 vor F2.** `when:always` ohne den Operanden-Fix macht aus „jede
gruene Pipeline rot am Guard" ein „JEDE Pipeline rot am Guard". Die Kopplung ist heute zirkulaer:
der rote `test:unit` verdeckt den Befund, der ihn melden koennte.

### (b) Der wiederholte Verify — Posten #81

Owner-Auftrag: *„der verify ueber die offenen und ungeprueften Bauposten von w0b muss wiederholt
werden, sobald w0b fertig zurueckkommt."* Der erste Durchgang lief ueber den Stand von 09:00 und
kennt **P-GLIED, beide Format-Fixes und alle Folge-Commits nicht**.

**Und er muss die Pipeline messen.** Die Lenses des ersten Durchgangs hatten eine benannte
Blindstelle — kein PAT seit dem Scrub. Sie ist geschlossen: der PAT liegt wieder vor, das
Helfer-Skript steht in `~/.claude/jobs/5a19728e/tmp/pipeline_debug.py` (liest den Wert blind,
gibt ihn nie aus).

### (c) P-D37B ist NICHT gelandet

`a881d468` in `wt-ce-d37b`. Der Dual-Review sagt: **nicht landen wie vorgelegt**, landefaehig
nach N1-N3 plus Bau-Pflicht L4. Danach bleibt D3-7b offen (Seite 1 von 3), bis super die Seiten
2+3 landet.

---

## 3. ZWEI OWNER-FRAGEN, DIE ARBEIT BLOCKIEREN

**(1) Wo steht MESS im Preimage?** Der Satz *„system vorn, organ hinten"* legt **zwei** Positionen
fest, nicht drei. Und die Frage ist heute **schaerfer geworden**: das Lager kennt beide Kandidaten
bereits — je einen pro Realm.

    {Format, measurement, system, organ}   ist die MESSDATEN-Kaskade
    {Format, system, organ, measurement}   ist die BINARIES-Kaskade   (D-12)

**Richtig gefragt: welcher Realm gibt die Preimage-Ordnung vor?** Der Fingerprint identifiziert
eine Binary (spraeche fuer Binaries), ist aber zugleich die Skip-Marke fuer Messdaten
(`lager_baum_writer.hpp:50-53`: Skip-Marke, minio-Key, `key_sha512` und Baum-Blatt sind
**dasselbe** Preimage). Ohne Antwort ist Ebene 3 nicht baubar.

**(2) Die Transpositions-Sperre als eigenes Paket?** Sie ist **ordnungsunabhaengig** und damit
ohne die MESS-Antwort baubar — sie verhindert das *Vertauschen* typgleicher Parameter, nicht die
*Reihenfolge*. Am Objekt vermessen: vier der sieben Preimage-Glieder tragen benannte Traegertypen,
die vorderen drei (`organ`, `system`, `measurement`) sind rohe `std::string_view`. Der reale
CEB-Pfad uebergibt organ und system **beide leer** — eine Vertauschung ist dort wertseitig
**unbeobachtbar**. Die Bauform steht in der Datei selbst (`:660-664`): in den gemeinsamen
`constexpr`-Kern, nicht zweimal.

Weiter offen: MinIO-**prod** (Vault hat nur dev) · OV-4 Mess-Deckel · die HY-Testvertraege im
Reserve-Wochenende (Designplan §8 legt es ausdruecklich dem Owner vor).

---

## 4. DIE LEHREN DES TAGES — sie sind der eigentliche Ertrag

### Die Riegel haben zurueckgeschlagen, und das war gut

`test_vs_taxonomie_klassen_grep` (der P14-Riegel von gestern) wurde rot und nannte
`pmc_vendor_registry.hpp` beim Namen — **die dritte Wiederholung der Klasse „(e)/(f)", und die
erste, die nicht ein Mensch, sondern der Riegel fand.** Der Absatz in `algo_semver.hpp`, der davor
warnt, hat sich selbst bestaetigt: die Luecke entsteht weiter, aber sie bleibt nicht liegen.

`test_t6_wachen_inventar` meldete „NEUE WACHE OHNE EINTRAG" — es waren **meine** zwei Skripte.

### Eine Warnungszahl ist nur so viel wert wie die `-W`-Flags des Ziels

**Dreimal an einem Tag, von drei Agenten.** Ein Ziel uebersetzt mit `-O3 -DNDEBUG -std=c++23` und
**keinem** `-W`; im Release-Baum tragen **227 von 585** Kommandos ueberhaupt eines. Zwei Agenten
haben ihre eigenen Zahlen daraufhin zurueckgezogen — einer, bevor es ihm jemand vorhielt.

Dazu: `ninja -t commands <ziel> | head -1` liefert den **C++20-Modul-Scan**, der nie warnt.
Aufgefallen ist es nur, weil ein gewuerfelter Koeder **nicht biss**.

### Die Zwei-Lens-Pflicht hat sich in einem Fall selbst begruendet

Beim Paket P-CI-CE klangen beide Verdikte gleich — **der schwerste Befund stand nur in einer
Lens**. Mehrheit oder Mittelung haette ihn verloren.

### Und die Bau-Strategie, jetzt Doktrin (A2.1, v3.2)

**Parallel bauen, sequentiell landen.** Die Serialisierung gehoert an die Landung: sie ist ohnehin
seriell (R4 + Ein-Blech) und kuerzer als ein Vollbau. Meine Umstellung auf sequentielles *Bauen*
nach dem Platten-Einbruch war die falsche Stelle — die echten Ursachen waren nicht abgeraeumte
Bauverzeichnisse und **zwei gleichzeitig laufende Workflow-Instanzen**.

**Die Lande-Stufe gehoert IN den Workflow** und landet den **Zweig**, nicht einen gemerkten SHA.
Heute zweimal belegt: ein vierter Commit lag nach dem Format-Commit und in null Remote-Refs.

---

## 5. MEINE EIGENEN FEHLER — vollstaendig, weil sie sonst wiederkommen

1. **`wt-ce-tax`: 162 Commits gemeldet, es war einer.** Ich hatte gegen einen lokalen
   Zwischen-Klon gemessen. `git ls-remote | cut -f1` traf eine `gh-scrub`-Zeile — die Ausgabe hat
   mehrere Zeilen.
2. **Einen laufenden Workflow nie gestoppt.** Drei Starts, zwei gestoppt. Fuenf Pakete wurden
   doppelt bearbeitet; „ein Schreiber je Worktree" war in fuenf Baeumen verletzt.
3. **Einen Worktree geloescht, waehrend ein Agent darin las.** Er hat es selbst gemeldet und sich
   an zwei anderen Baeumen gerettet.
4. **Aus 45 Log-Zeilen „eine Datei" geschlossen** — es waren drei. Ein Log-Schwanz ist kein Log.
5. **Fast eine eigene Prueformel benutzt**: 41 Verstoesse in einem Vendor-Baum, den die CI gar
   nicht prueft. Die CI-Formel ist die CI-Formel.
6. **„r7 endgueltig verloren"** — falsch. Ein anderer Agent hat `bcf6bc97` im geteilten ce-Store
   geborgen. Ich hatte in vier Worktrees gesucht, nicht im Store. **#77 ist ein Lande-Auftrag.**
7. **Eine Agenten-Vermutung als Befund weitergegeben**: „eine zweite Fundstelle der Klasse" — es
   war dieselbe Stelle, reproduziert.
8. **Die Lager-Ordnung mit der Stufen-Ordnung vermengt.** Mein „vierfach belegt" nahm eine
   realm-spezifische Ordnung fuer die allgemeine.
9. **`pkill -f` traf zweimal die eigene Shell.**

---

## 6. WERKZEUGE, DIE JETZT DA SIND

    ~/.claude/jobs/5a19728e/tmp/pipeline_debug.py   Pipeline+Jobs ueber die API,
                                                    PAT blind aus dem Vault, nie ausgegeben
    ~/.claude/jobs/5a19728e/tmp/joblog.py           Job-Log holen (ACHTUNG: druckt nur den
                                                    Schwanz -- die Gesamtzeilenzahl pruefen!)
    clang-format 22.1.8                             /home/comdare/tools/cf22/... und
                                                    /usr/lib/llvm-22/bin/ -- beide identisch
                                                    (`pip` gibt es auf prod1 NICHT)

Der PAT: `vault-query gitlab --status any` → Rolle `gitlab-keeper-adminmgmt-master-2026`,
md5 `c8f7975c`, len 51, `current`, `CREDENTIALS-VAULT-DEV.md:535`. **Nie greppen, nie ausgeben.**

---

## 7. BILANZ DER KERN-EXPLORES — 21 Pakete an einem Tag

    STIMMT              4
    STIMMT_TEILWEISE   10
    SCHON_ERLEDIGT      6
    STIMMT_NICHT        1

**Vier von einundzwanzig Aufgabendefinitionen trugen ihren Kern unveraendert.** Sechs Auftraege
waren **nie verlangt** — sie entstanden aus stalen Ledger- und Task-Notaten und banden Kraefte,
waehrend die zehn F1-Posten liegen blieben.

> Das ist die Rechtfertigung der Stufe 0 und zugleich ihre Grenze: sie verhindert falsche Arbeit,
> aber sie liefert keine. **Am Freitag zaehlt, was im PDF steht.**
