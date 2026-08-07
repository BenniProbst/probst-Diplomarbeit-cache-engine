# VORLAGE — Lizenzwahl für CacheEngine, PRT-ART und Diplomarbeits-Code (super)

Stand: 2026-08-07 · Recherche-Vorlage, **keine Entscheidung, keine Rechtsberatung**
Gegenstand: die drei Repos der **BEP Venture UG (haftungsbeschränkt)**, Marke **Comdare**.
Nicht Gegenstand: der Thesis-Text selbst — der bleibt privates Copyright Benjamin-Elias Probst.

---

## EMPFEHLUNG (drei Zeilen)

1. **Schiene 1 (öffentlich): PolyForm Noncommercial 1.0.0** für alle drei Repos — sie ist die einzige geprüfte Standardlizenz, die Einsicht, Übersetzen, Linken und Modifizieren *für Forschung und Lehre* ausdrücklich erlaubt, jede kommerzielle Nutzung sperrt und **nie** automatisch zu Open Source umschlägt.
2. **Schiene 2 (kommerziell): Einzelvertrag der BEP Venture UG** — kein Lizenztext im Repo, nur ein Kontaktverweis. Das ist genau die Konstruktion, die `ce/LICENSE` seit dem 02.08. schon hat; PolyForm ersetzt nur den selbstgeschriebenen Text durch einen anwaltlich verfassten, SPDX-gelisteten.
3. **Warum nicht die Alternativen:** BSL 1.1 und FSL erzwingen eine Umstellung auf Open Source (4 bzw. 2 Jahre) — das widerspricht „möglichst restriktiv". Elastic 2.0 erlaubt kommerziellen Verkauf. CC BY-NC-ND verbietet das Ändern und damit praktisch das Arbeiten mit dem Code.

---

## VORBEDINGUNGEN — was vor dem Umstellen geklärt sein muss

| # | Punkt | Status | Blockiert? |
|---|---|---|---|
| V1 | **liburing fehlt in beiden Lizenzdateien** | **bestätigt offen** | ja, klein |
| V2 | libxlsxwriter / zlib / minizip / MPL-Header | **bereits nachgetragen** | nein |
| V3 | Drei Allokator-Abweichungen Thesis ↔ Akte | offen (Task #42) | ja, für die Abgabe |
| V4 | GPL-3- und LGPL-Code im Baum | **entschärft** — wird nicht gebaut | nein |
| V5 | „Architekt-Direktive II" trägt die Lizenzierung nicht | offen | ja, konzeptionell |
| V6 | Thesis-Sperrvermerk nennt super + PRT-ART = Apache-2.0 | **Widerspruch zum neuen Wunsch** | ja |
| V7 | super und PRT-ART stehen faktisch auf Apache-2.0 | bestätigt | ja |

### V1 — liburing steht in keiner der beiden Lizenzdateien (bestätigt)

Nachgeprüft am aktuellen `origin/development` (`f2709599`):

```
git show origin/development:NOTICE               | grep -i liburing   -> 0 Treffer
git show origin/development:LICENSE_AUDIT_EXT.md | grep -i liburing   -> 0 Treffer
```

Das Verzeichnis liegt seit dem 23.07. im Baum: `/home/comdare/wt-landung/ext/io/liburing/`, Tag `liburing-2.6`, Commit `f7dcc1ea`. Die Provenienz-Akte `ext/io/liburing/COMDARE-VENDOR-PROVENANCE.md:14` weist die Lizenz aus: **MIT (liburing ist dual MIT/GPL)**; im Verzeichnis liegen `LICENSE`, `COPYING` und `COPYING.GPL`.

**Fachlich ist das ungefährlich** — MIT ist permissiv, und der Comdare-Bau nutzt den MIT-Zweig. **Formal ist es eine echte Lücke**: das NOTICE ist die Datei, mit der die Attributionspflicht erfüllt wird. Wer eine restriktive Lizenz auflegt, muss die Fremdanteile lückenlos ausweisen, sonst ist die zentrale Aussage („alles außer ext/ gehört uns") nicht belegt. **Ist eine Vorbedingung — aber eine kleine: ein Absatz im NOTICE und eine Zeile in der Audit-Tabelle.**

Zusätzlich zu klären: liburing ist **dual MIT/GPL**. Bei einer Dual-Lizenz wählt der Nutzer. Die Provenienz-Akte sagt, dass der MIT-Zweig gilt — dieser Satz gehört ins NOTICE, nicht nur in die Provenienz-Datei.

### V2 — libxlsxwriter, zlib, minizip, MPL-Header: bereits erledigt

Hier weicht der Befund von der Auftragsannahme ab. Diese Bibliotheken liegen **nicht** im lokalen Arbeitsbaum `wt-landung` (Branch `bau/flag-grammatik-v2-s1`, 22 Commits zurück), sondern kamen am **07.08. um 16:41 UTC** auf `origin/development` (Kette `01fc66b2` → `5c96165f` → `bc2d418c`, „A9-S1: Vendor-Snapshots"). Und sie sind dort **vollständig verbucht**, `LICENSE_AUDIT_EXT.md:43-49`:

| Baustein | Lizenz | Vermerk |
|---|---|---|
| `ext/io/libxlsxwriter` v1.2.4 | BSD-2-Clause (FreeBSD) | ✅ |
| `· queue.h`/`tree.h` | BSD | ✅ |
| `· third_party/minizip` | zlib-Lizenz | ✅ |
| `· third_party/md5` | Public Domain | ✅ |
| `· third_party/dtoa` | MIT | ✅ |
| `· third_party/tmpfileplus` | **MPL-2.0** | ⚠️ **nicht gebaut** |
| `ext/io/zlib` v1.3.2 | zlib-Lizenz | ✅ |

Der MPL-2.0-Punkt ist sauber behandelt: `tmpfileplus.h` trägt den Mozilla-Kopf und wird von `src/utility.c:22` unbedingt inkludiert, aber der `.c`-Teil ist geprunt und `USE_STANDARD_TMPFILE` schaltet auf POSIX `tmpfile()`. Belegt mit `nm libcomdare_vendored_xlsxwriter.a | grep -ci tmpfileplus` → `0`. **MPL-2.0 ist file-level-Copyleft: die Datei behält ihre Lizenz und färbt nichts ein.** Das ist richtig eingeordnet. Kein Handlungsbedarf.

### V3 — Drei Allokator-Abweichungen (Task #42)

Betroffen: **`michael_lockfree` (A03), `tcmalloc` (A06), `lrmalloc` (A11)**.

| Profil | Akte (Registry-XML) | Thesis-Tabelle | PAPER_REFERENCES.md |
|---|---|---|---|
| `michael_lockfree` | `LGPL-2.1-or-later` | `BSD-3` | `MIT (Re-Impl; IBM-Patent)` |
| `tcmalloc` | `Apache-2.0` | `BSD-3` | — |
| `lrmalloc` | `MIT` | `BSD-3` | — |

Quellen: `libs/cache_engine/algorithm_profiles/allocators/*.profile.xml:9` · `kapitel/de/03_state_of_the_art.tex:477,480,484` (und drei weitere Tabellenkopien, DE+EN) · `libs/cache_engine/axes/alloc/PAPER_REFERENCES.md:14`.

Ursache: am 13.07. wurde die **Akte** korrigiert (`ce 5768faeb`), die Thesis wurde nicht nachgezogen — das Gate greift nicht über Repo-Grenzen (Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:8992-9002`).

Zusätzlicher Fund, im „drei Abweichungen"-Befund noch nicht enthalten: **A03 ist auch innerhalb des ce-Repos uneinheitlich** — `LICENSE_AUDIT_EXT.md:25` sagt „KEINE LICENSE", `NOTICE:320` sagt „MIT (per repository README)", `NOTICE:514` listet A03 zugleich unter „No-LICENSE", und das Profil-XML sagt LGPL-2.1-or-later. **Vier Quellen, drei Aussagen.**

**Warum das für die Lizenzwahl zählt:** eine restriktive Lizenz steht und fällt mit der Aussage, dass der Rechtsstand des Fremdcodes bekannt ist. Solange dieselbe Bibliothek in vier Dateien drei Lizenzen trägt, ist diese Aussage nicht belegt. **Ist eine Vorbedingung.** Die Reihenfolge sollte sein: erst die Akte auf einen Stand bringen, dann die Thesis nachziehen (DE führt, EN nachziehen), dann lizenzieren.

### V4 — GPL-3 und LGPL im Baum: die Entwarnung

Das ist die härteste Randbedingung, und sie löst sich auf. Im Baum liegen GPL-3-lizenzierte Vendor-Bäume (**P04-CoCo-trie**, **P07-Wormhole**) und LGPL-2.1+-Code (**P29-RCU/userspace-rcu**, **A03-michael-lockfree**). **Nichts davon wird gebaut.** Selbst nachgeprüft:

```
adapters/P07-Wormhole/CMakeLists.txt:4
  option(COMDARE_HAVE_WORMHOLE "... (GPL-3)" OFF)
  add_library(comdare_adapter_p07_wormhole INTERFACE)
adapters/P04-CoCo-trie/CMakeLists.txt:4     option(COMDARE_HAVE_COCOTRIE ... OFF)
adapters/P29-RCU/CMakeLists.txt:3           option(COMDARE_HAVE_LIBURCU ... OFF)
adapters/A03-michael-lockfree/CMakeLists.txt:2  option(COMDARE_HAVE_MICHAEL ... OFF)
```

Alle vier sind `INTERFACE`-Bibliotheken — die kompilieren nichts, sie tragen nur Include-Pfade weiter. Der Vendor-Include-Pfad wird erst *innerhalb* des `if(...)`-Blocks gesetzt, und die Adapter-Header schützen jeden Zugriff mit `#if defined(...)`. **Kein Ort im Repo setzt einen dieser Schalter auf ON** — nicht `.gitlab-ci.yml`, nicht `CMakePresets.json`, nicht die Root-`CMakeLists.txt`. Eigener Gegen-Grep über alle CMake-, YAML-, JSON-, Shell- und Header-Dateien: die Symbole erscheinen ausschließlich in den vier Adapter-Verzeichnissen selbst.

Bei A03 kommt eine zweite, unabhängige Sperre dazu: die eigentliche Mess-Achse braucht `COMDARE_HAVE_MICHAEL_LF`, das nirgends per `set()` zugewiesen wird, und die Datei `michael_lf.h` existiert im Repo überhaupt nicht. Die Achse fällt immer auf einen Stub zurück, der `std::malloc` meldet (`name()` → `"michael_lockfree(real=std)"`).

**Konsequenz:** Es wird kein Copyleft-Code übersetzt oder gelinkt. Die Frage „darf ein Repo mit solchem Fremdcode restriktiv lizenziert werden?" ist damit **ja** — unter vier Bedingungen:

1. Die eigene Lizenz erfasst **nur den Comdare-Eigencode**, nie „dieses Repositorium". Der Satz in der LICENSE muss den Fremdcode ausdrücklich ausnehmen.
2. Jeder Fremdcode behält seine **Original-LICENSE-Datei** an Ort und Stelle. (Ist erfüllt — das NOTICE sagt es zu, und die Dateien liegen dort.)
3. Das **NOTICE weist jede Komponente aus** — deshalb ist V1 eine Vorbedingung.
4. Es bleibt bei **bloßer Beifügung** („mere aggregation"): das GPL-Werk wird mitverteilt, aber nicht in ein kombiniertes Werk gelinkt. Genau das ist der Ist-Zustand.

**Was das nicht heißt:** GPL-3-Code wird weiterhin *mitverteilt*. Wer das Repo weitergibt, verteilt GPL-3-Werke mit — zulässig, solange sie unter GPL-3 bleiben und der Empfänger den Quelltext bekommt (er bekommt ihn, es ist ein Quelltext-Repo). Aber: **wenn jemals `COMDARE_HAVE_WORMHOLE=ON` oder `COMDARE_HAVE_COCOTRIE=ON` gebaut wird, ist die restriktive Lizenz für dieses Artefakt nicht mehr haltbar** — GPL-3 und eine Nicht-Kommerz-Klausel schließen sich aus. Ein CI-Gate, das diese vier Schalter hart auf OFF nagelt, wäre die technische Absicherung der Lizenzaussage.

### V5 — Die „Architekt-Direktive II" trägt die Lizenzierung nicht

Im NOTICE steht ab Zeile 469 eine Direktive vom 14.05., die den Umgang mit GPL/LGPL/No-License regelt. Wortlaut (`NOTICE:471-481`):

> „Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht fuer alle Permutations-Achsen in CacheEngine und SearchEngine separat ein neues Werk. Das bedeutet, wir koennen den Code bedenkenlos herauskopieren, per Adapter geschnipselt in Bausteine mit dem original Compiler bauen, und final verwenden. […] Das gilt fuer alle Lizenztypen. Repos ohne Lizenztypen haben nur ein formales copyright, also muss nur der Autor beim zitieren genannt werden."

Daran anschließend zieht das NOTICE selbst die Folgerung, die GPL-3-Klausel „Conveying Verbatim Copies" greife nicht (`NOTICE:502-506`).

Drei Feststellungen, ohne Rechtsmeinung:

- Die Direktive ist eine **Eigenerklärung des Projektinhabers**. Es gibt in der Akte keine Korrespondenz mit den Rechteinhabern (Boffa/CoCo-trie, Wu/Ni/Jiang/Wormhole, McKenney/userspace-rcu), keine gesonderte Lizenzvereinbarung, keine anwaltliche Freigabe.
- Die ältere Fassung (`docs/lizenzen/20260508-1500-lizenzen_uebersicht.md:7-17`) enthält den Satz „Wenn es keine Lizenz gibt, dann ist im Forschungskontext auch keine beabsichtigt." **Dieselbe Datei hält an anderer Stelle (`:127`) das Gegenteil fest: „Ohne LICENSE bedeutet streng 'All Rights Reserved'."** Die zweite Aussage entspricht dem Urheberrecht, die erste nicht.
- Ursprünglich war eine **Lizenzanfrage an die Autoren** vorgesehen (`:86-88`). Sie wurde durch die Direktive ersetzt, nicht durch eine eingeholte Freigabe.

**Praktisch ist das entschärft:** wie unter V4 gezeigt, wird der fragliche Code gar nicht gebaut, die Direktive wird also für den Ist-Zustand nicht gebraucht. **Sie sollte trotzdem nicht als Begründung in einer Lizenzdatei stehen** — eine restriktive Lizenz, die sich auf eine bestrittene Rechtsauffassung stützt, ist schwächer als eine, die sich auf einen sauberen Bauzustand stützt. Empfehlung: die Direktive im NOTICE stehen lassen (Doku nie löschen), aber die **Lizenzaussage darauf umstellen, was messbar ist**: „Copyleft-Komponenten unter `ext/` sind vom Bau ausgenommen; die Schalter stehen auf OFF."

### V6 / V7 — Der Widerspruch zum Sperrvermerk der Thesis

**Das ist der wichtigste Punkt dieser Vorlage.** Die Thesis trägt bereits einen Sperrvermerk mit einer ausdrücklichen Lizenzaussage — am gepinnten Commit `eaf7fe87`, `diplomarbeit.tex:219-226`:

> **Lizenzen und Copyright** — Der Code des Diplomarbeits-Repositories (Mess-Treiber und Auswertungs-Pipeline) sowie der Prüfling PRT-ART **stehen unter Apache-2.0**. Der Software-Kern der `comdare-cache-engine` steht unter einem dualen Lizenzmodell […]. Der Text dieser Arbeit unterliegt dem privaten Copyright von Benjamin-Elias Probst.

Und der Sperrvermerk selbst (`:209-217`):

> **Sperrvermerk (eingeschränkt)** — Diese Arbeit selbst unterliegt keinem Sperrvermerk. Ein eingeschränkter Sperrvermerk betrifft **allein den Software-Kern der comdare-cache-engine**: Er ist zur Begutachtung einsehbar und testbar; eine geschäftliche Nutzung oder Weitergabe über die Begutachtung hinaus bedarf einer gesonderten Lizenz […]. Ausgenommen ist die Forschung […].

Der Ist-Zustand deckt sich damit: `super/LICENSE` = Apache-2.0 (201 Zeilen), `prt-art/LICENSE` = Apache-2.0 (201 Zeilen, Blob `2668ab65`), `ce/LICENSE` = die selbstgeschriebene Dual-Lizenz vom 02.08.

**Der heutige Wunsch — alle drei restriktiv — ändert diese gedruckte Aussage.** Zwei Folgen:

- **Die Thesis muss nachgezogen werden**, DE führt, EN nachziehen. Betroffen: `diplomarbeit.tex:219-226` (DE) und `:238-244` (EN). Das ist ein Textblock, keine große Arbeit — aber er steht im Prüfungsdokument, und der Kommentarblock darüber (`:196-206`) markiert ihn als „ENTWURF […] finale Owner-Freigabe vor Abgabe". Das Fenster ist also offen.
- **Apache-2.0 lässt sich nicht rückwirkend zurücknehmen.** Wer eine Revision unter Apache-2.0 erhalten hat, behält diese Rechte dauerhaft. `ce/LICENSE:23-26` macht das bereits richtig („Revisions […] published before 2026-08-02 were licensed under the Apache License 2.0; that grant remains valid for those earlier revisions"). Derselbe Vermerk muss in super und PRT-ART. Das ist kein Problem, aber es muss dastehen, sonst ist die Lizenzdatei unwahr.

---

## DIE KANDIDATEN — Vergleich gegen die fünf Kriterien

Kriterien aus der Owner-Anforderung: **(1)** Quelltext einsehbar · **(2)** Übersetzen und Linken erlaubt, auch *gegen* die Bibliothek · **(3)** kein gewerblicher Verkauf durch Dritte · **(4)** freie Forschung ausdrücklich erlaubt · **(5)** so restriktiv wie möglich, ohne 1–4 zu verletzen.

| Kandidat | (1) Einsicht | (2) Compile/Link | (3) Kein Verkauf | (4) Forschung frei | (5) Restriktivität | Urteil |
|---|---|---|---|---|---|---|
| **PolyForm Noncommercial 1.0.0** | ja | ja, für erlaubte Zwecke; Linken nicht benannt, aber vom breiten Copyright-Grant gedeckt | ja — *jede* kommerzielle Nutzung gesperrt | **ja, ausdrücklich** (eigener Abschnitt) | hoch, dauerhaft | **empfohlen** |
| **Prosperity Public License 3.0.0** | ja | ja, wie PolyForm | ja, aber **30 Tage Kommerz-Trial** | ja, gleicher Wortlaut | hoch minus Trial | Zweitwahl |
| **PolyForm Internal Use 1.0.0** | ja | ja | ja | **nein** — Weitergabe komplett verboten | sehr hoch | untauglich als Schiene 1 |
| **PolyForm Free Trial 1.0.0** | ja | ja | ja | **nein** — 32 Tage, keine Weitergabe | sehr hoch | nur als 3. Schiene |
| **BSL 1.1** | ja | ja | ja, **bis zur Change Date** | über „Additional Use Grant" formulierbar | **läuft nach max. 4 J. aus** | Ausschluss (V5-Konflikt) |
| **FSL 1.1** | ja | ja | nur gegen Wettbewerber | ja | **läuft nach 2 J. aus** | Ausschluss |
| **Elastic License 2.0** | ja | ja | **nein** — Verkauf/kommerzielle Nutzung erlaubt | ja (implizit) | niedrig | Ausschluss (K3) |
| **Fair Source** | — | — | — | — | — | **keine Lizenz, eine Definition** |
| **CC BY-NC-ND 4.0** | ja | **nein** — ND verbietet Bearbeitungen | ja | ja, aber NC unscharf | hoch, aber falsch | Ausschluss (K2) |
| **Commons Clause + Apache-2.0** | ja | ja | ja, aber „Sell" ist weit gefasst | ja | mittel | nur bei Lesart A (s.u.) |

### PolyForm Noncommercial 1.0.0 — die Empfehlung

Volltext geprüft. Die Copyright-Klausel ist bewusst breit: *„The licensor grants you a copyright license for the software to do everything you might do with the software that would otherwise infringe the licensor's copyright in it for any permitted purpose."* Damit sind Einsehen, Übersetzen, Linken und Modifizieren erfasst — sie werden nicht einzeln aufgezählt, weil die Klausel alles greift, was ohne Lizenz eine Urheberrechtsverletzung wäre.

**Ist Linken eindeutig geregelt? Nein, es ist nicht benannt — aber es ist auch nicht beschränkt.** Das ist ein anderer Fall als bei GPL/LGPL: dort ist Linken geregelt, *weil* daran eine Copyleft-Folge hängt. PolyForm hat kein Copyleft. Wer gegen die Bibliothek linkt, muss sein eigenes Werk nicht unter PolyForm stellen. Die einzige Grenze ist der Zweck. Das ist für die Anforderung „compile und linken" die passende Konstruktion — **mit einer Einschränkung, siehe den Entscheidungspunkt unten.**

**Wie ist „kommerziell" definiert?** Über die Gegenrichtung: erlaubt ist „any noncommercial purpose", und zwei Abschnitte präzisieren das. *Personal Uses:* „research, experiment, and testing for the benefit of public knowledge, personal study, private entertainment, hobby projects, amateur pursuits, or religious observance, without any anticipated commercial application". *Noncommercial Organizations:* „any charitable organization, **educational institution, public research organization**, public safety or health organization, environmental protection organization, or government institution […] **regardless of the source of funding**".

Der letzte Halbsatz ist für eine Diplomarbeit wertvoll: eine Universität bleibt auch dann eine erlaubte Nutzerin, wenn ihr Lehrstuhl drittmittelfinanziert ist. Damit ist Kriterium 4 nicht nur erfüllt, sondern **härter erfüllt als mit einem selbstgeschriebenen Satz** — „für Forschung und Lehre frei nutzbar" (der heutige ce-Text) lässt offen, ob ein industriefinanziertes Institut darunterfällt. PolyForm beantwortet das.

**Trifft es interne Firmennutzung?** **Ja.** Interne Nutzung in einem Unternehmen ist kein „noncommercial purpose" und damit nicht lizenziert — auch wenn nichts verkauft wird. Das ist restriktiver als die Owner-Formulierung „kein gewerblicher Verkauf" und deckt sich mit „so restriktiv wie möglich". Es ist aber der Punkt, an dem der Owner entscheiden muss (siehe Entscheidungspunkt 1).

**Weiteres:** Patentlizenz enthalten, mit Defensivklausel (wer Patentklagen erhebt, verliert sie). Heilungsfrist von 32 Tagen bei erstmaliger Verletzung — angenehm, weil ein Versehen nicht sofort alles beendet. Unterlizenzierung und Übertragung ausgeschlossen (`No Other Rights`), was für den Rechteinhaber gut ist. Ausdrücklicher Vorbehalt zugunsten „fair use". SPDX-Kennung: **`PolyForm-Noncommercial-1.0.0`** — das ist wichtig, weil Werkzeuge zur Lizenzprüfung sie kennen; ein selbstgeschriebener Text wird von jedem Scanner als „unbekannt" gemeldet.

**Präzedenz:** verfasst von Kyle E. Mitchell (Anwalt, spezialisiert auf Software-Lizenzen). In Gebrauch u. a. bei Education Analytics für Software des öffentlichen Sektors. **Ich habe keine Streitigkeiten oder Gerichtsentscheidungen zu PolyForm gefunden** — was zweischneidig ist: keine bekannten Probleme, aber auch keine gerichtliche Bestätigung.

**Versionsstand:** **1.0.0 ist die aktuelle stabile Fassung.** Eine 2.0.0 ist in Arbeit, stand November 2025 als `2.0.0-pre.2` und ist bis heute nicht final. Es gibt keine Empfehlung des Herausgebers, auf sie zu warten. **1.0.0 nehmen.**

### Prosperity Public License 3.0.0 — die Zweitwahl

Gleiche Familie, gleicher Autor, fast gleicher Wortlaut bei den erlaubten Zwecken (die Abschnitte „Personal Uses" und „Noncommercial Organizations" sind praktisch identisch). Der Unterschied: Prosperity räumt eine **kommerzielle Probezeit von 30 Tagen** ein. Zusätzlich zählt es das Zurückgeben von Änderungen unter MIT/Apache-2.0/BSD ausdrücklich nicht als kommerzielle Nutzung.

Der 30-Tage-Trial ist genau das, was Kriterium 5 kostet: er ist eine Einladung an ein Unternehmen, den Code einen Monat lang produktiv zu betreiben. **Wenn der Owner diesen Trial ausdrücklich will** — als niedrigschwelligen Einstieg für spätere Lizenznehmer — ist Prosperity die bessere Wahl. Will er ihn nicht, ist PolyForm NC dasselbe minus dieser Lücke.

### PolyForm Internal Use 1.0.0 — für dieses Ziel untauglich

Volltext geprüft. Sie erlaubt genau das Gegenteil dessen, was hier gebraucht wird: erlaubter Zweck ist „the internal business operations of you and your company" — also **kommerzielle interne Nutzung** —, während die Copyright-Klausel ausdrücklich sagt: *„you may not distribute the software."*

Für die Anforderung ist das doppelt falsch: sie öffnet die kommerzielle Innennutzung (verletzt Kriterium 5) und schließt die Weitergabe an Forscher (verletzt Kriterium 4). **Als Schiene 1 ausgeschlossen.** Sie hätte einen denkbaren Platz als *Vorlage für die kommerzielle Schiene 2* — ein Unternehmen, das intern nutzen, aber nicht weitergeben darf. Das ist aber eine Vertragsfrage, keine Repo-Lizenz.

### Business Source License 1.1 — Ausschluss wegen der Change Date

Die Mechanik: Bis zur „Change Date" gilt nur „non-production use", plus optional ein „Additional Use Grant", mit dem der Lizenzgeber begrenzte Produktivnutzung freigibt. **Ab der Change Date schlägt die Lizenz automatisch in die „Change License" um** — eine echte Open-Source-Lizenz. Und: **die Change Date ist Pflicht und darf höchstens vier Jahre nach der ersten öffentlichen Verteilung liegen.**

Das ist der Ausschlussgrund. Der Owner will „möglichst restriktiv"; BSL garantiert das Gegenteil — sie ist ein **Verfallsdatum auf die Restriktion**. Wer BSL wählt, verspricht öffentlich, den Code spätestens 2030 unter Apache/MIT freizugeben.

Zwei weitere Punkte. Erstens: **BSL definiert „production" nicht.** Das ist der meistkritisierte Defekt — jeder Lizenzgeber legt über den Additional Use Grant selbst fest, was gilt, und die Praxis geht weit auseinander (HashiCorp: alles außer Wettbewerbsprodukten; MariaDB: weniger als drei Server-Instanzen). Faktisch ist jede BSL-Anwendung eine eigene Lizenz — was die Vergleichbarkeit zerstört und für einen kleinen Lizenzgeber schlecht ist. Zweitens: die Umstellung von HashiCorp auf BSL im August 2023 löste erheblichen Widerstand aus und führte zum Fork OpenTofu. Das ist ein Reputationsrisiko, das ein Forschungsprojekt nicht braucht.

### Elastic License 2.0 — Ausschluss, sie verletzt Kriterium 3

Der Grant ist weit: „use, copy, distribute, make available, and prepare derivative works". Beschränkt wird nur dreierlei: kein Anbieten als **gehosteter oder verwalteter Dienst**, kein Umgehen von Lizenzschlüsseln, kein Entfernen von Vermerken.

Was das bedeutet: **kommerzielle Nutzung ist erlaubt, auch der Einbau in ein verkauftes Produkt.** ELv2 ist eine Anti-Cloud-Lizenz, keine Anti-Kommerz-Lizenz — sie wurde geschrieben, um AWS daran zu hindern, Elasticsearch als Dienst anzubieten. Für eine Bibliothek, die niemand als SaaS betreiben würde, ist die einzige wirksame Beschränkung dieser Lizenz gegenstandslos, und die kommerzielle Verwertung durch Dritte bleibt offen. **Verfehlt Kriterium 3 und 5 deutlich.**

### Prosperity vs. Fair Source vs. FSL — die Kategorien auseinanderhalten

**Fair Source ist keine Lizenz.** Es ist eine Definition, verwaltet auf GitHub, 2024 von Sentry initiiert. Software ist Fair Source, wenn sie drei Kriterien erfüllt: „is publicly available to read", „allows use, modification, and redistribution with minimal restrictions to protect the producer's business model", und — entscheidend — **„undergoes delayed Open Source publication (DOSP)"**.

DOSP ist definiert als „the practice of distributing or publicly deploying software under a proprietary license at first, then **subsequently and in a planned fashion publishing that software's source code under an Open Source (OSI-approved) license**". Die Definition benennt DOSP ausdrücklich als „a key differentiator".

**Damit ist Fair Source mit der Anforderung unvereinbar.** Eine Lizenz, die dauerhaft restriktiv bleibt, ist per Definition nicht Fair Source. Als Fair Source anerkannt sind derzeit: **FSL**, **Fair Core License (FCL)** und **BSL** — alle drei mit eingebauter Konvertierung. Wer „möglichst restriktiv, dauerhaft" will, sucht nicht in dieser Kategorie.

**FSL 1.1** ist die verbesserte BSL: sie beseitigt die Additional-Use-Grant-Beliebigkeit, indem sie die Zielsprache auf **Apache-2.0 oder MIT** festnagelt, und verkürzt die Frist von vier auf **zwei Jahre**. Als Bibliotheks-Lizenz ist sie außerdem inhaltlich schief: sie verbietet „Wettbewerbsnutzung" — ein Begriff, der für ein SaaS-Produkt Sinn ergibt, für eine Forschungsbibliothek aber kaum bestimmbar ist. **Ausschluss, aus demselben Grund wie BSL, nur zwei Jahre früher.**

### CC BY-NC-ND — warum davon für Software abgeraten wird

Vier Gründe, in absteigender Härte:

1. **Das „ND" verbietet Bearbeitungen.** Für Software heißt das: Der Nutzer darf nichts anpassen — keinen Patch, keine Portierung, kein Anpassen an einen anderen Compiler. **Damit verletzt CC BY-NC-ND Kriterium 2 unmittelbar.** Ob schon das Übersetzen des Quelltexts eine „Bearbeitung" ist, ist zusätzlich streitig. Genau diese Unsicherheit will man bei einer Bibliothek nicht.
2. **Creative Commons selbst rät davon ab.** Die CC-Lizenzen sind für Inhalte gemacht, nicht für funktionale Werke; CC verweist für Software auf MIT/GPL. Eine Lizenz gegen den ausdrücklichen Rat ihres Herausgebers zu verwenden, ist im Streitfall eine schlechte Ausgangslage.
3. **„NonCommercial" ist unschärfer als bei PolyForm.** Die CC-Definition stellt darauf ab, ob eine Nutzung „primarily intended for or directed toward commercial advantage or private monetary compensation" ist — eine Absichtsprüfung. PolyForm zählt stattdessen erlaubte Nutzergruppen auf. Das ist im Zweifel leichter zu belegen.
4. **CC-Lizenzen regeln software-spezifische Fragen nicht.** Keine Patentlizenz, keine Regeln zu Quelltext gegenüber Binärform, keine Haftungsarchitektur für ausführbaren Code, keine Aussage zum Linken.

**CC BY-NC-ND ist damit nicht „zu restriktiv", sondern in der falschen Richtung restriktiv:** sie sperrt das, was der Owner erlauben will (Ändern, Kompilieren), und regelt das nicht sauber, was er sperren will.

### PolyForm Free Trial 1.0.0 — nur als dritte Schiene

Volltext geprüft: erlaubter Zweck ist die Evaluierung, ob die Software für eine bestimmte Anwendung taugt, „for less than 32 consecutive calendar days", und die Weitergabe ist untersagt.

Als Hauptlizenz untauglich (keine Forschungsschiene, keine Weitergabe). **Sinnvoll ist sie als ausdrücklich benannte dritte Schiene**, falls der Owner Unternehmen einen definierten Evaluierungspfad geben will, ohne gleich zu verhandeln. Das ist eine Vertriebsentscheidung, keine technische — und es ist die sauberere Variante des 30-Tage-Trials, den Prosperity fest eingebaut hat, weil sie getrennt bleibt und einzeln zurückgenommen werden kann.

### Commons Clause — die einzige Option, die wörtlich nur „Verkauf" verbietet

Commons Clause ist kein eigenständiger Lizenztext, sondern ein **Zusatz**, der auf eine OSI-Lizenz aufgesetzt wird (typisch Apache-2.0). Er nimmt aus dem Grant das Recht heraus, die Software zu „sell" — wobei „Sell" weit definiert ist und Beratung, Support und Hosting einschließt, deren Wert sich wesentlich aus der Software ergibt.

Damit ist Commons Clause **die einzige geprüfte Konstruktion, die die Owner-Formulierung wörtlich abbildet**: einsehen, kompilieren, linken, intern nutzen — nur nicht verkaufen. Wenn Lesart A gewollt ist (siehe Entscheidungspunkt 1), führt hier der Weg lang. Drei Gründe sprechen trotzdem dagegen:

- **Namensverwirrung mit Ansage.** „Apache-2.0 mit Commons Clause" liest sich für Unbeteiligte wie Apache-2.0, ist es aber nicht. Genau daran entzündete sich 2018 die Kritik an Redis; die Vorwürfe reichten von „irreführend" bis „vermischt die Bedeutung von Open Source". Distributionen wie Fedora und Debian mussten prüfen, ob sie die Module noch ausliefern dürfen.
- **Redis hat es wieder aufgegeben.** Nach dem Backlash ersetzte Redis Labs die Konstruktion im Februar 2019 durch eine eigene Lizenz (RSAL), ausdrücklich um die Verwechslung mit Apache zu beenden. Ein Modell, dessen prominentester Anwender es nach sechs Monaten verwarf, ist ein schwacher Anker.
- **Auslegungsrisiko bei „Sell".** Die weite Definition erfasst Beratung und Support. Wo genau ein Forschungsinstitut, das Drittmittel einwirbt, in dieses Raster fällt, ist unklarer als bei PolyForms Aufzählung erlaubter Organisationen.

**Urteil: nur wenn Lesart A ausdrücklich gewollt ist — und dann besser als eigener, klar benannter Zusatz zu PolyForm NC statt als Commons Clause auf Apache-2.0.**

---

## DIE DOPPELLIZENZIERUNG — wie sie praktisch funktioniert

Der Begriff führt hier leicht in die Irre. Was gebraucht wird, ist **keine Doppellizenzierung im technischen Sinn** (dasselbe Werk gleichzeitig unter zwei Lizenzen zur Wahl des Nutzers, wie bei liburing MIT/GPL). Gebraucht wird:

- **eine öffentliche Lizenz** im Repo — PolyForm NC —, die für alle gilt, die den Code einfach herunterladen; und
- **die Möglichkeit, davon abweichende Einzelverträge zu schließen** für Nutzer, die mehr wollen.

Die zweite Schiene braucht **keinen Lizenztext im Repo**. Sie folgt daraus, dass die BEP Venture UG Rechteinhaberin ist: Wer die Rechte hält, kann sie beliebig oft und zu beliebigen Bedingungen einräumen. PolyForms Klausel `No Other Rights` sagt das ausdrücklich mit — die Lizenz hindert den Lizenzgeber nicht daran, anderen andere Lizenzen zu erteilen. In die LICENSE gehört deshalb nur ein Verweis: *für kommerzielle Nutzung wenden Sie sich an […]*. Das ist genau das, was `ce/LICENSE:14-18` heute schon tut.

**Was „alle Rechte halten" bei vendoriertem Fremdcode bedeutet — die entscheidende Präzisierung:** Der Grundsatz „wer doppelt lizenziert, muss alle Rechte halten" gilt **für das Werk, das lizenziert wird** — nicht für alles, was im selben Verzeichnisbaum liegt. Fremdcode unter `ext/` wird **nicht mitlizenziert**; er behält seine eigene Lizenz, und die Comdare-Lizenz sagt das ausdrücklich. Damit ist die Rechte-Vollständigkeit nur für den Comdare-Eigencode zu belegen, und das ist gegeben.

Zwei Fallstricke, die genau hier lauern:

1. **Die LICENSE darf nie „dieses Repositorium" sagen.** Sie muss den Gegenstand benennen: den Comdare-Eigencode, unter ausdrücklicher Ausnahme von `ext/`. `ce/LICENSE:28-29` hat diesen Satz bereits — er ist knapp, aber er ist da. Für super und PRT-ART muss er neu geschrieben werden.
2. **Sobald Fremdcode in ein kombiniertes Werk einfließt, ändert sich die Lage.** Statisch gelinkter MIT-/BSD-Code ist unproblematisch (Attribution genügt, deshalb das NOTICE). Statisch gelinkter GPL-Code wäre es nicht. Der heutige Bauzustand linkt nur permissive Komponenten (mimalloc MIT statisch; jemalloc/tcmalloc/hoard/scalloc dynamisch gegen Systempakete; liburing MIT nur im io_uring-Pfad; libxlsxwriter BSD-2 nur im Test). **Damit ist die Voraussetzung erfüllt — sie ist aber an den Bauzustand geknüpft und muss dort abgesichert werden.**

---

## DIE HOCHSCHUL-SEITE — kollidiert eine restriktive Lizenz mit der TU Dresden?

**Kurz: nach dem, was ich belegen konnte, nein.** Mit einer klaren Einschränkung am Ende.

**Rechteinhaberschaft.** Die TU Dresden hat ein Hinweisblatt „Hinweise und Vereinbarungsformular zu Verwertungsrechten von Studienabschlussarbeiten und Qualifikationsschriften". Wörtlich:

> „Abschlussarbeiten sind grundsätzlich urheberrechtlich geschützt, d. h. die jeweiligen Autor:innen sind im Besitz der Rechte für die Nutzung und Verwertung ihrer Arbeiten. **Das Urheberrecht steht in den meisten Fällen allein [den Autor:innen] und nicht der betreuenden Professur oder der Universität zu.** […] Etwas anderes gilt nur dann, wenn die Erfindung im Rahmen eines Dienstverhältnisses geschaffen wurde."

Und weiter, zu den Grenzen, die die Universität sich selbst setzt:

> „1. Weder die Ausgabe des Studien- oder Abschlussarbeitsthemas, noch die Entscheidung über die Annahme als Doktorand:in oder Habilitand:in darf vom Abschluss einer Schutzrechtsvereinbarung abhängig gemacht werden. […] 3. Eine Vereinbarung, wodurch die Abtretung von Schutzrechten unentgeltlich erfolgt, ist in der Regel nicht zulässig."

**Das ist die Antwort auf die Kernfrage:** Die Rechte liegen beim Prüfling, nicht bei der Universität. Die TU Dresden nimmt sich keine Rechte an der Software und macht die Themenvergabe ausdrücklich nicht von einer Rechteabtretung abhängig. **Eine restriktive Lizenz kollidiert damit nicht** — vorausgesetzt, es wurde keine Schutzrechtsvereinbarung geschlossen. Das ist eine Tatsachenfrage, die nur der Owner beantworten kann.

**Sperrvermerk.** Es gibt einen, und er ist bereits formuliert — siehe V6. Er ist eng gefasst („Diese Arbeit selbst unterliegt keinem Sperrvermerk"), was die übliche und praktikable Variante ist: Der Text bleibt prüfbar und zitierbar, nur die Software ist beschränkt. Wichtig ist der bereits enthaltene Satz, dass der Kern „zur Begutachtung einsehbar und testbar" ist — er stellt die Prüfbarkeit sicher, die eine Nutzungsbeschränkung sonst gefährden könnte. **Dieser Satz muss erhalten bleiben, egal welche Lizenz gewählt wird.** PolyForm NC deckt ihn ohnehin ab, weil Prüfer an einer Universität unter „educational institution" fallen.

**Veröffentlichungs- oder Archivierungspflicht — hier bin ich unsicher.** Ich habe die Prüfungsordnung Diplom-Informatik der TU Dresden (Fassung 2010) heruntergeladen und maschinell durchsucht. Die Suche nach `Exemplar`, `Veröffentlichung`, `Archiv`, `Aufbewahrung`, `Bibliothek` ergab **keine Treffer im Sachteil** — aber die Textextraktion war unzuverlässig (gesperrte Zeichenauszeichnung, das Dokument ist zudem eine Entwurfsfassung mit dem Platzhalter „Vom #Ausfertigungsdatum#"). **Ich betrachte diesen Negativbefund als nicht belastbar und sage das ausdrücklich, statt daraus eine Entwarnung zu machen.**

Was ich zusätzlich geprüft habe: Die Anmeldeunterlagen im Repo enthalten nichts dazu. `Formular-Anmeldung-Abschlussarbeit.pdf` ist das Fakultätsformular und regelt nur Zulassung, Fristen und Prüfer — keine Erwähnung von Veröffentlichung, Rechten, Lizenz, Sperrvermerk oder Archivierung. `20260502 Anmeldung_DA_Probst.pdf` ist ein reiner Scan ohne Textebene und war nicht auswertbar. Die drei E-Mail-PDFs (Kühn, Schüle, Zhang) sind Anfragen an fremde Paper-Autoren nach Referenzcode, keine Betreuer-Korrespondenz.

**Der allgemeine Grundsatz** — Abschlussarbeiten unterliegen anders als Dissertationen keiner Publikationspflicht — spricht dafür, dass hier nichts kollidiert. **Aber ich habe ihn für die Fakultät Informatik der TU Dresden nicht am Normtext belegen können.** Das ist eine Frage an das Prüfungsamt oder an Prof. Habich, und sie ist mit einer E-Mail zu klären.

---

## WAS ZU TUN IST — Reihenfolge

Die Reihenfolge ist nicht beliebig: die Vorbedingungen müssen vor der Lizenzumstellung stehen, weil die Lizenz auf ihnen aufsetzt.

**Stufe 0 — Entscheidungen des Owners.** Ohne sie ist nichts von unten ausführbar. Siehe „Entscheidungspunkte" am Ende.

**Stufe 1 — Aktenlage schließen (ce-Repo).**
1. `NOTICE` — Abschnitt für **liburing** ergänzen: Pfad `ext/io/liburing/`, Upstream, Tag `liburing-2.6`, Commit `f7dcc1ea`, Lizenz **MIT** mit dem ausdrücklichen Satz, dass aus der Dual-Lizenz MIT/GPL der **MIT-Zweig** gewählt wird.
2. `LICENSE_AUDIT_EXT.md` — Zeile für liburing in die Vendor-Tabelle (neben die bereits vorhandenen `io/`-Einträge für libxlsxwriter und zlib).
3. **A03 vereinheitlichen.** Vier Quellen, drei Aussagen: `LICENSE_AUDIT_EXT.md:25` („KEINE LICENSE"), `NOTICE:320` („MIT per README"), `NOTICE:514` („No-LICENSE"), `michael_lockfree.profile.xml:9` („LGPL-2.1-or-later"). Maßgeblich ist der Lizenzkopf der Datei selbst: `ext/allocator/A03-michael-lockfree/michael.h:1-17` nennt **LGPL-2.1**. Alle vier Stellen darauf ziehen.

**Stufe 2 — Thesis nachziehen (Task #42).**
4. `kapitel/de/03_state_of_the_art.tex:477,480,484` und `kapitel/de/03_messsystem_prtart.tex:233,236,240` auf die korrigierten Werte (michael_lockfree LGPL-2.1-or-later, tcmalloc Apache-2.0, lrmalloc MIT). **DE führt.**
5. Dieselben Zeilen in `kapitel/en/…:457,460,464` und `:230,233,237` **nachziehen**. Die Angabe steht in vier Tabellenkopien — alle vier.

**Stufe 3 — Lizenzdateien setzen.** Erst jetzt.
6. **ce:** `LICENSE` durch den PolyForm-NC-1.0.0-Volltext ersetzen, ergänzt um vier Zeilen darüber: Rechteinhaberin (BEP Venture UG, Marke Comdare), `Required Notice:`-Zeile (PolyForm wertet plain-text-Zeilen mit diesem Präfix aus und verpflichtet Empfänger, sie weiterzugeben), Verweis auf die kommerzielle Schiene, **Historien-Vermerk** (Apache-2.0 für Revisionen vor dem 02.08.2026 bleibt wirksam — der Satz steht in `ce/LICENSE:23-26` bereits und muss erhalten bleiben) und der Ausnahmesatz für `ext/`.
7. **PRT-ART:** dasselbe. Aktuell Apache-2.0 (Blob `2668ab65`, 201 Zeilen). Historien-Vermerk **neu** schreiben, mit dem Datum der Umstellung.
8. **super:** dasselbe. Aktuell Apache-2.0 (201 Zeilen). **Hier zusätzlich ein `NOTICE` anlegen — super hat bisher keines.** Es muss das eingebettete ce (Submodul `Code/external/comdare-cache-engine`) und PRT-ART benennen und auf deren NOTICE verweisen.

**Stufe 4 — Sichtbarkeit.**
9. `README.md` in allen drei Repos: Lizenzabschnitt auf die neue Lage. Wichtig ist der Hinweis, dass es **keine** OSI-Open-Source-Lizenz ist — das gehört an die sichtbare Stelle, nicht ins Kleingedruckte.
10. **Datei-Header:** PolyForm verlangt keine Header. Empfohlen ist trotzdem eine SPDX-Zeile in neuen Comdare-Quelldateien: `// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0`. **Ein Massenlauf über den Bestand ist nicht nötig und würde nur Diff-Rauschen erzeugen** — die LICENSE im Wurzelverzeichnis genügt rechtlich. Neue Dateien mitnehmen, alte in Ruhe lassen.
11. `docs/lizenzen/INDEX.md` und `docs/lizenzen/20260508-1500-lizenzen_uebersicht.md` tragen noch „Hauptlizenz Projekt: Apache License 2.0" (Stand 08.05.) und **keinen Stale-Hinweis**. Nach Hausregel nicht löschen, sondern als überholt markieren und auf die neue Lage verweisen.

**Stufe 5 — Absichern.**
12. **CI-Gate für die vier Copyleft-Schalter.** Die gesamte Lizenzaussage hängt daran, dass `COMDARE_HAVE_WORMHOLE`, `COMDARE_HAVE_COCOTRIE`, `COMDARE_HAVE_LIBURCU` und `COMDARE_HAVE_MICHAEL` OFF bleiben. Heute ist das wahr, aber nur durch Konvention — nichts erzwingt es. Ein Gate, das anschlägt, sobald einer dieser Schalter irgendwo auf ON gesetzt wird, macht aus einer Behauptung eine geprüfte Eigenschaft. **Das ist die einzige Codeänderung in dieser Liste, und sie ist die wertvollste.**

---

## WO ICH UNSICHER BIN

**Ich gebe keine Rechtsberatung.** Die folgenden Punkte sind anwaltlich, nicht recherchierbar:

1. **Ob die Rechte tatsächlich bei der BEP Venture UG liegen.** Nach dem TU-Dresden-Hinweisblatt entsteht das Urheberrecht an einer Abschlussarbeit **beim Prüfling** — hier also bei Benjamin-Elias Probst persönlich, nicht bei der UG. Eine Übertragung auf die Gesellschaft ist möglich, muss aber vertraglich erfolgt sein. Die Eigentumslage wurde als festgestellt vorgegeben, und ich behandle sie als gesetzt. **Ob sie dokumentiert ist, konnte ich nicht prüfen, und es ist die Voraussetzung dafür, dass die UG überhaupt lizenzieren kann.** Anwaltlich.

2. **Ob eine Schutzrechtsvereinbarung mit der TU besteht.** Falls doch eine unterzeichnet wurde, verschiebt sich die gesamte Lage. Nicht aus dem Repo erkennbar.

3. **Ob die Prüfungsordnung Veröffentlichung oder Archivierung verlangt.** Meine Suche im PDF ergab keine Treffer, **aber die Extraktion war unzuverlässig** und das Dokument eine Entwurfsfassung. Ich behandle das nicht als Entwarnung. Eine E-Mail ans Prüfungsamt klärt es.

4. **Ob „Linken gegen die Bibliothek" unter PolyForm eindeutig ist.** Meine Einschätzung — der breite Copyright-Grant deckt es, und ohne Copyleft gibt es keine Rückwirkung — ist eine Auslegung, keine Feststellung. Der Lizenztext benennt Linken nicht. Wenn dieser Punkt geschäftskritisch wird, gehört er in die kommerzielle Schiene, wo er ausdrücklich geregelt werden kann.

5. **Ob die „Architekt-Direktive II" trägt.** Ich habe dargelegt, worauf sie sich stützt und worauf nicht (V5). Die Bewertung, ob das Zerschneiden fremder Algorithmen ein neues Werk begründet, ist eine urheberrechtliche Frage zur Schöpfungshöhe. **Ich beantworte sie nicht.** Für den Ist-Zustand wird sie nicht gebraucht, weil der fragliche Code nicht gebaut wird — das ist der Punkt, an dem ich die Lizenzaussage aufhängen würde.

6. **Keine gerichtliche Bestätigung für PolyForm.** Ich habe keine Streitigkeiten gefunden. Das ist kein Beleg für Wirksamkeit, nur für Abwesenheit bekannter Probleme.

7. **Eine Beobachtung, keine Empfehlung:** Nicht-kommerzielle Lizenzen erschweren die Nachnutzung in der Forschung mehr, als es zunächst wirkt — sie sind mit GPL-Projekten unvereinbar, und manche Institute dürfen nichts einsetzen, was nicht OSI-konform ist. Für die Sichtbarkeit einer Diplomarbeit ist das ein Preis. **Der Owner hat die Richtung vorgegeben, und sie ist legitim** — dies ist nur der Hinweis, dass der Preis existiert.

---

## ENTSCHEIDUNGSPUNKTE FÜR DEN OWNER

**E1 — Welche Lesart von „kein gewerblicher Verkauf"?** Die Anforderung lässt zwei zu:

- **Lesart A (eng):** Jeder darf einsehen, kompilieren, linken — auch ein Unternehmen intern. Verboten ist nur der **Weiterverkauf**. → Dafür gibt es keine gute Standardlizenz; der nächste Kandidat wäre Commons Clause, mit den beschriebenen Nachteilen.
- **Lesart B (weit):** Nur Forschung und Lehre dürfen nutzen; **jede** geschäftliche Nutzung braucht einen Vertrag. → **PolyForm Noncommercial 1.0.0.**

**Der heutige `ce/LICENSE`-Text und der Sperrvermerk in der Thesis sind beide eindeutig Lesart B**, und „so restriktiv wie möglich" zeigt in dieselbe Richtung. **Empfehlung: B.** Das ist aber die eine Stelle, an der ich raten müsste, wenn niemand bestätigt.

**E2 — Wird der Sperrvermerk in der Thesis geändert?** Er sagt heute gedruckt: super und PRT-ART = Apache-2.0. Der neue Wunsch widerspricht dem. Entweder die Thesis wird nachgezogen (DE `diplomarbeit.tex:219-226`, EN `:238-244`) — oder es bleibt bei Apache-2.0 für diese beiden, und nur ce wird restriktiv. **Beides ist vertretbar; nur beides gleichzeitig geht nicht.** Der Kommentarblock über dem Sperrvermerk markiert ihn als Entwurf mit ausstehender Owner-Freigabe, das Fenster ist also offen.

**E3 — Prosperity statt PolyForm, wegen des 30-Tage-Trials?** Der einzige inhaltliche Unterschied. Der Trial ist ein Verkaufsargument (Unternehmen können ausprobieren) und zugleich eine Lücke (ein Monat kostenlose Produktivnutzung). Wenn der Trial gewollt ist, aber kontrollierbar bleiben soll, ist die sauberere Variante **PolyForm NC + PolyForm Free Trial als getrennte, ausdrücklich benannte dritte Schiene**.

---

### Belege — Kurzverzeichnis

| Aussage | Quelle |
|---|---|
| ce steht auf Dual-Lizenz (02.08.) | `/home/comdare/wt-landung/LICENSE:1-29` |
| super steht auf Apache-2.0, kein NOTICE | `/home/comdare/wt-super-landung/LICENSE` (201 Z.) |
| PRT-ART steht auf Apache-2.0 | Blob `2668ab65` am Pin `c6f07540` (201 Z.) |
| liburing fehlt in NOTICE und Audit | `git show origin/development:{NOTICE,LICENSE_AUDIT_EXT.md} \| grep -i liburing` → 0 |
| liburing ist MIT (dual MIT/GPL) | `ext/io/liburing/COMDARE-VENDOR-PROVENANCE.md:14` |
| A9-S1-Vendors sind verbucht | `LICENSE_AUDIT_EXT.md:43-49` (origin/development `f2709599`) |
| MPL-Header nicht gebaut | `LICENSE_AUDIT_EXT.md:48`; `nm … \| grep -ci tmpfileplus` → 0 |
| GPL-3-Schalter stehen OFF | `adapters/P04-CoCo-trie/CMakeLists.txt:4`, `adapters/P07-Wormhole/CMakeLists.txt:4` |
| LGPL-Schalter stehen OFF | `adapters/P29-RCU/CMakeLists.txt:3`, `adapters/A03-michael-lockfree/CMakeLists.txt:2` |
| Kein Ort setzt sie auf ON | Repo-weiter Grep über CMake/YAML/JSON/Shell/Header |
| Drei Allokator-Abweichungen | `*/allocators/*.profile.xml:9` ↔ `kapitel/{de,en}/03_*.tex` ↔ `axes/alloc/PAPER_REFERENCES.md:14` |
| Architekt-Direktive II | `NOTICE:471-481`; `docs/lizenzen/20260508-1500-lizenzen_uebersicht.md:7-17` |
| Widerspruch im selben Dokument | `docs/lizenzen/20260508-1500-lizenzen_uebersicht.md:127` |
| Sperrvermerk und Lizenzaussage | `diplomarbeit.tex:209-226` (DE), `:229-244` (EN), Pin `eaf7fe87` |
| Rechte liegen beim Prüfling | TU Dresden, „Hinweise und Vereinbarungsformular zu Verwertungsrechten…" |
| PolyForm NC 1.0.0 Volltext | polyformproject.org/licenses/noncommercial/1.0.0 |
| PolyForm NC 2.0.0 noch pre-release | writing.kemitchell.com, 05.11.2025 (`2.0.0-pre.2`) |
| BSL Change Date max. 4 Jahre | mariadb.com/bsl11 |
| Fair Source verlangt DOSP | fair.io/about |
| Commons Clause bei Redis zurückgenommen | Redis Labs, Februar 2019 (RSAL) |
