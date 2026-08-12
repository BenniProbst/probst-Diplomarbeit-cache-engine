# KONTEXTÜBERGABE 12.08.2026 — NACHT 8: VIERZEHN KON-NACHTRÄGE, DER BAU BEGINNT, UND EIN LÖSCH-VORFALL

> **Stand:** Mi 12.08.2026, abends · **F1 ÜBERMORGEN** (Fr 14.08.) · F2 Fr 21.08. ·
> Bau-Trigger Mi 26.08. 06:00 · **T−3-Anker ~Sa 12.09.** · Abgabe Di 15.09.
> **Einstieg für die Nachfolge:** Ledger-Kopf **KON49 → KON36** lesen, dann die
> **LEDGER-KONSOLIDIERUNG IV** (Kapitel A–M mit ERGÄNZT-Blöcken) → dieses Dokument →
> `docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md` **Teil B = die Strecke**.
> **Zwei Sperren beachten:** (1) das **Monats-Spend-Limit ist erreicht** — Subagenten sterben
> sofort; (2) die **Fable-max-Order** gilt bis Widerruf (nur Memory, keine Arbeitsregel).

---

## IN EINEM SATZ

Vierzehn KON-Nachträge (KON36…KON49) haben die Architektur zu Ende geklärt, die vier
/goal-Dokumente zu Haupt-Referenzen gemacht und den Bau gestartet — **ein Strang ist gelandet
und vollständig belegt, zwei warten fertig geschnitten auf den Neubau**, und ein Lösch-Vorfall
hat eine neue Werkzeug-Regel erzwungen.

---

## 1. DIE BILANZ DIESES KONTEXTS

| | |
|---|---|
| **Ledger** | 24.378 → **25.848 Zeilen** · **14 Nachträge** (KON36…KON49) · Konsolidierung IV um 56 Fakten ergänzt |
| **Owner-Entscheide** | **FR-1…FR-4 · OF-1…OF-5 · v3.5-GO · zwei Struktur-Festlegungen** (Träger-Unterprojekte · Fable-max-Order) — **offene Owner-Fragen: NULL** |
| **Workflows** | WF7 (8/8) · WF8 (10/10) · WF9 (5/5) · WF10 (geheilt, 5/5) · WF11 (**9/12** — 3 Bau-Agenten am 529) · WF12 (**0/4** — Spend-Limit) |
| **Landungen** | super `4ca12b56` → **`6f03349a`** · ce `9bb664d6` → **`a99c4a18`** · Umbrella `6ac0ac9` (v3.5) · Cluster `1d7b5d0` (Handout) — alle Remotes, jede gitleaks-Null köder-gedeckt |
| **Betrieb** | Platte **2,9 G → 24 G** frei · 289-Token rotiert · super-Pipeline **grün** (15752) · ce-Pipeline **läuft** (15751, Monitor aktiv) |

---

## 2. DER BAU — WO DIE DREI STRÄNGE STEHEN

### 🟢 Strang D (ce grünen, #14/#83) — GELANDET UND VOLLSTÄNDIG BELEGT

**ce `a99c4a18`** (beide Remotes), 5 Commits, **864+/205−** über vier Dateien.
**Vollständigkeitsprüfung des Schnitts am Objekt (P1–P7, jede Zahl gemessen):**

    P1 #83 CI-Formel-Paritaet   COMDARE_LINT_PATHS 7 · --nur=format 12 · Version 22.1.8 3
    P2 F1a SOLL-DELTA           COMDARE_FREMD_SOLL_DELTA_BLOECKE 6 im Guard
    P3a Host-Probe publiziert   ctest_unit_host_probe 4 in der CI-YAML
    P3b Fremd-Probe Pflicht     COMDARE_FREMD_HOST_PROBE 7 im Guard
    P4 Reparaturtext            verworfener Satz 0 Treffer (korrekt ENTFERNT)
    P5 Selbsttest               12 st_fall-Zeilen (10 Faelle + Rahmen)
    P6 F2 when:always           2 · P7 [HISTORIE] 2
    Gegenprobe: 'coverage-guard' 8 Treffer -> das Werkzeug misst wirklich.

**Der Diff wurde vom Lead selbst nachgeprüft** (V1): 0 `allow_failure`/`when: never`,
Gegenprobe biss (das eine gewollte `when: always`). **Pipeline 15751 läuft** — Monitor gesetzt,
meldet rote Jobs und den Endstatus. Die drei #84-Testdateien sind planmäßig erst **nach** dem
Pipeline-Ergebnis neu zu erheben.

### 🟡 Strang C (F1-DURCHSTICH) und Strang A (S-1 Basisklasse) — SCHNITTE FERTIG, BAU OFFEN

Beide Bau-Agenten starben in WF11 am **serverseitigen 529**, der Neubau (WF12) am
**Spend-Limit** — **ohne eine Zeile Code zu erzeugen** (dreifach belegt, s. §4).
**Die Schnitte sind vollständig geborgen und liegen bereit:**

    docs/sessions/backups/.../kon-quellen/wf11-design-3.json   = STRANG C (P1..P10)
    docs/sessions/backups/.../kon-quellen/wf11-design-2.json   = STRANG A (P1..P9 + WARTE-Liste)
    (Arbeitskopien: ~/.claude/jobs/5a19728e/tmp/wf11-design-{2,3}.json)
    Das WF12-Skript ist wiederverwendbar (Branch-Pflicht + Verify-Korrekturen drin):
    .../workflows/scripts/wf12-neubau-strang-c-und-a-wf_cd576b6e-94e.js

**🔴 Zwei Verify-Korrekturen am C-Schnitt sind VOR dem Bau einzuarbeiten** (stehen im Skript):
1. **P8:** die neuen Bissproben-Fälle heißen **F27/F28**, nicht F20/F21 — F20/F21 sind belegt
   (`bissprobe:449-452` keine-CSV, `:460-483` Leerzeilen; höchste vergebene Nummer **F26**).
2. **P4:** der hochzuziehende Block ist **:528-532**; die SOTA-Schleife **:533-534** konsumiert
   `sota_measurement_stamp`, gehört zur fused-Befüllung und darf **nicht** mit hochgezogen werden.

**Der C-Kern in einem Satz:** der Katalog-Emitter emittiert für Basis-320-Zellen die 2-arg-Form
ohne Mess-Zeile, das Prüfgate verlangt die Vollmenge ⇒ `deklaration_leer, measured=0, exit=1`
(KON44-01). Der Fix zieht die Mess-Zeile durch **beide** Pfade (Katalog + lazy) — nach
Owner-Entscheid **Option (a) am Planer-Teil** (KON47-01). Preimage-Wirkung gewollt, heute
kostenlos.

---

## 3. WAS DER OWNER IN DIESEM KONTEXT ENTSCHIEDEN HAT

**Architektur/Bau:** F1-Weg = **(a) Planer-Teil** · **vier Träger-Unterprojekte** im ce, Bau
strikt **PLANER→CEB→TIER→HYBRID „und nicht anders"**, Monolith-Split beim Aufräumen (KON43) ·
je Vertragsgrenze prüfen · **Hybrid-Stempel**: erbt Tier + **Komposit-Map-Zeile** (vorletzte),
SHA deckt die Dock-Belegung; Map-VALUE = **Tier-SHA**, volle Stempel per **Init-Cache** über
Fläche 2 zur Laufzeit (KON41-04/KON47-02) · **Festplatten-IO voll bauen**, wenn an der Reihe ·
**Dock-32 = willkürlicher Programm-Deckel**, W7-anpassbar · **Default-Doktrin**: Variablen hart
als Planer-Defaults einkompiliert, XML überschreibt · **Hybrid zweiwegig XML-steuerbar**
(statische Dock-Belegung ODER Synthese-Funktionen+Wirkbereiche) (KON42).

**Messung/Betrieb:** 🔴 **das Warmup-PAAR** — messen+verwerfen, messen+speichern, **dreimal**
(6 Läufe, 3 einzeln persistierte Werte); `--debug` **einmal kalt**; **sonst IMMER zwei Mal**,
Pflicht für die Forschung, **testpflichtig** (KON47-04) · **Generalproben-Doktrin**: der volle
Lauf fährt dauernd als Generalprobe, bei **T−3 manueller Reset** (Builds **und** Messdaten),
dann der finale Lauf; CI zuerst, lokal nachziehen (KON41-01) · T-15b: Build **und** Messung je
**5** Fehlversuche.

**Prozess:** **v3.5-GO** (15 Regeln, im Umbrella gelandet) · **Fable-5-max-Order überall bis
Widerruf** (ausdrücklich **nur Memory**, keine Arbeitsregel) · Stempel-Strecke dauerhaft
Fable max (KON38).

---

## 4. 🔴 DER LÖSCH-VORFALL — WAS GESCHAH UND WAS DARAUS FOLGT

**Was geschah:** Beim Aufräumen wurden elf Worktrees entfernt; geprüft wurde je Worktree nur
*„ist der **super-HEAD** Vorfahr von `origin/development`?"*. In diesem Projekt liegt die
Bau-Arbeit aber fast immer im **ce-Submodul** — der super-HEAD kann gelandet sein, während im
Submodul ein ungelandeter Branch hängt. **Strang D wurde nur gerettet, weil ein Verify-Bericht
seinen Branch namentlich nannte** und er vorher ins Haupt-ce geholt wurde.

**Bergungs-Bilanz — nichts von diesem Tag ist verloren, dreifach gemessen:**

    (1) Der ce-Submodul-Store ist GETEILT (.git/modules/...): 'worktree remove' loescht das
        ARBEITSVERZEICHNIS, nicht den Store -- Commits auf benannten Branches ueberleben.
    (2) fsck ueber ALLE DREI Objektspeicher: super 2 dangling (11.08. gelandet + eine
        Zwischenstufe von heute, deren Inhalt VOLLSTAENDIG gelandet ist: diff 0 Zeilen,
        Gegenprobe 86) · ce-Hauptklon 1 (10.08., gelandet) · ce-GETEILT 20+ (juengster
        10.08. 14:47) -- KEIN EINZIGER von heute.
    (3) Die Verify-Messungen VOR der Loeschung decken sich: "ce-Worktree byte-identisch zu
        development, git status sauber, 0 untracked, 0 stash".
    ⚠️ Das ist GLUECK, nicht Methode: haette D in einem der zehn anderen Worktrees gelegen,
    waere sein Arbeitsverzeichnis weg gewesen.

**🔴 Die neue Löschregel (KON49-02, Memory-Eintrag angelegt):** **erst landen, dann löschen** —
und vor jedem `worktree remove` in **jedem** Worktree `log --all` über **super UND jedes
Submodul**, **jeden Branch-Tip einzeln** gegen den Remote (nicht den HEAD, **alle Refs**).
Dazu die **Branch-Pflicht** für Bau-Agenten: auf **benanntem** Branch committen (nicht detached
HEAD), und der Verify weist **Branch + Store-Pfad** aus.

**Nebenbefund (echte offene Arbeit, kein Verlust von heute):** im geteilten ce-Store liegen
**13 ungelandete Branches vom 02.–10.08.** — drei vom **10.08.** (`bau/p2-warnstufe-aufteilen`
· `bau/p6-lizenz-umsetzung` · `bau/p3-ci-clang-pflicht`, je 1 Commit; ihre super-Seiten sind
gelandet, die ce-Seiten nie), fünf W2-Branches (02.08.), drei PMC-Branches (06.08.),
`w0a/d2-floor` (09.08.). **Vor dem main-FF (#19) zu klären: landen oder begründet ausbuchen.**

---

## 5. DIE ZWEI SPERREN, DIE DIE NÄCHSTE SESSION KENNEN MUSS

1. **🔴 MONATS-SPEND-LIMIT ERREICHT.** WF12 starb daran mit 0 von 4 Agenten. **Jeder
   Subagenten-/Workflow-Start scheitert sofort**, bis das Limit angehoben oder der Monat neu
   ist. **Konsequenz:** C und A müssen **direkt vom Lead** gebaut werden (die Schnitte sind
   vollständig, s. §2) — oder der Owner hebt das Limit.
2. **Die Fable-max-Order** (Memory, bis Widerruf): alle Agenten/Phasen `{model:'fable',
   effort:'max'}`. Beim Widerruf gilt wieder die A1-Matrix **plus** KON38 (Stempel bleibt
   Fable max, das ist eine eigene, dauerhafte Regel).

---

## 6. DER BETRIEBSSTAND

    super  development = 6f03349a   Pipeline 15752 GRUEN      beide Remotes
    ce     development = a99c4a18   Pipeline 15751 LAEUFT     beide Remotes (Monitor aktiv)
    Umbrella (Projekte) = 6ac0ac9   ARBEITSWEISE v3.5         nur GitLab
    Cluster            = 1d7b5d0    Vault-Handout 289         nur GitLab
    Gitlink super->ce: bewusst NICHT gebumpt (F1 faehrt den geprueften Stand)

    Platte  24 G frei (war 2,9 G -- vier Bauverzeichnisse belegt-geprueft geraeumt,
            elf Worktrees entfernt). Verbleibend: 6 Worktrees, davon wf_d826aca8-6ce-8
            (traegt den D-Store, kann nach gruener Pipeline weg).
    289     COMDARE_THESIS_WRITEBACK_USER/TOKEN gesetzt (Token r20260812, expires 30.11.);
            Kopie 0600 in ~/keys/; Vault-Nachtrag liegt als Handout bei Infra.
    Runner  24 sichtbar, 15 online; prod1+prod2 baremetal online.

---

## 7. DIE ERSTEN SCHRITTE DER NÄCHSTEN SESSION

1. **Neu gründen:** die vier /goal-Dokumente (jetzt MIT Referenz-Nachträgen: GOAL-Kopf ·
   Wellenplan **§17** · Designplan **§10**) + ARBEITSWEISE **v3.5** aus dem Umbrella.
2. **Ledger-Kopf:** KON49 → KON36, dann Konsolidierung IV. Dieses Dokument. Dann
   **Plan-Dokument Teil B** (die Strecke mit kritischem Pfad).
3. **ce-Pipeline 15751 prüfen** (Monitor-Ergebnis oder API): grün ⇒ #14 schließen und
   `wf_d826aca8-6ce-8` entfernen (**nach der neuen Löschregel!**); rot ⇒ Job-Log lesen,
   Ausweichform ist ein eigener Job (Dualreview W2).
4. **🔴 Strang C bauen — das ist die F1-Lieferung, Freitag ist übermorgen.** Schnitt:
   `wf11-design-3.json` + die zwei Verify-Korrekturen (§2). Abnahme ist der Mini-Lauf aus
   `MANUAL_RUN.md §8b` mit **measured=1 und echten Werten** (kein n/a-Phantom).
5. **Strang A** (S-1 Basisklasse, `wf11-design-2.json`) — kritischer Pfad Richtung F2;
   Datei-Mengen sind disjunkt zu C (geprüft), die WARTE-Liste W-A…W-D bleibt liegen.
6. Danach nach Strecke: golden → Homes (#16) → S-6-Fenster (#15) → S-19 (#7) vor dem Trigger.

---

## 8. WAS AUSDRÜCKLICH OFFEN BLEIBT

* **Die 13 ungelandeten ce-Branches** (§4) — vor dem main-FF entscheiden.
* **Der ##25-Durchstich fährt noch nicht** (Strang C ungebaut) — F1-Lieferung in Gefahr,
  wenn C nicht am Donnerstag steht.
* **Die stille n/a-Falle** (KON44-02): eine provisionierte Zeile passiert zwei von drei
  Wachen — der Härtungs-Posten ist Teil des C-Schnitts (P7/P8).
* **Der OV-4-Deckel** wird vom T−3-Fenster her neu kalibriert (KON41-01) — braucht die
  S-19-Zahlen, W2-Posten vor der GO-Vorlage.
* **Vom Owner unbeantwortet: nichts.** Alle Fragen sind geschlossen (KON42-02).

---

*Erhoben 12.08.2026 abends. Jede Zahl am Objekt gemessen oder mit KON-Anker; wo eine frühere
Aussage von mir gefallen ist (die ce-Sequenz-Auflage, die Worktree-Prüfung), steht die
Korrektur dabei — der Bestand an Irrtümern ist selbst ein Datum.*
