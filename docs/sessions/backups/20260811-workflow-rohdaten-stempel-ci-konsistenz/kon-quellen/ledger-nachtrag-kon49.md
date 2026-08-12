## NACHTRAG 12.08.2026 — KON49: WF11 — DREI AGENTEN-TODE AM API-OVERLOAD, EINE VOREILIGE WORKTREE-LÖSCHUNG, UND WAS DIE BESTANDSAUFNAHME ERGAB

**WF11 (`wf_d826aca8`) kam mit 9 von 12 Agenten zurück: die DREI BAU-Agenten starben an einem
serverseitigen API-Overload (529). Danach wurden im Aufräumen elf Worktrees entfernt — mit einer
Prüfung, die den Gegenstand verfehlte. Dieser Nachtrag hält den Vorfall, die Bergungs-Bilanz und
die daraus folgende Löschregel fest.**

---

### KON49-01 — WF11-ERGEBNIS: NUR STRANG D HAT GEBAUT

    STRANG D (ce gruenen)      LANDEFAEHIG_MIT_FIXES -- der Agent hatte VOR seinem Tod
                               bereits committet: 5 Commits, 864+/205- ueber 4 Dateien
                               (ci_test_coverage_guard.sh +552 · dessen Selbsttest +230 ·
                               vor_push_alle_wachen.sh +233 · .gitlab-ci.yml)
    STRANG C (F1-Durchstich)   NICHT_LANDEFAEHIG -- nichts gebaut (Tod vor dem ersten Edit)
    STRANG A (S-1 Basisklasse) NICHT_LANDEFAEHIG -- nichts gebaut
    Die SCHNITTE aller drei Straenge (Explore+Design, 9 ueberlebende Agenten) sind
    VOLLSTAENDIG erhalten und aus dem journal.jsonl geborgen -- inklusive zweier
    Verify-Korrekturen am C-Schnitt (s. KON49-04).

---

### KON49-02 — 🔴 DER LÖSCH-VORFALL: DIE PRÜFUNG MASS DEN FALSCHEN GEGENSTAND

    WAS GESCHAH: elf gelandete Worktrees wurden entfernt, geprueft wurde je Worktree
    NUR "ist der SUPER-HEAD Vorfahr von origin/development?".
    WARUM DAS FALSCH IST: in diesem Projekt liegt die Bau-Arbeit fast immer im
    ce-SUBMODUL, nicht im super-Baum. Der super-HEAD kann gelandet sein, waehrend im
    Submodul ein ungelandeter Branch haengt -- genau so lag Strang D (er wurde nur
    deshalb gerettet, weil der Verify-Bericht seinen Branch NAMENTLICH nannte und er
    vor dem Loeschen ins Haupt-ce geholt wurde).
    KLASSE: Stellvertreter (V0/TEIL IV) -- "super-HEAD gelandet" wurde fuer "Worktree
    enthaelt nichts Ungelandetes" genommen.

**🔴 DIE LÖSCHREGEL (neu, gilt ab sofort):** vor jedem `git worktree remove` wird in **jedem**
Worktree `log --all` über **super UND jedes Submodul** gefahren und **jeder Branch-Tip einzeln**
gegen den Remote geprüft — nicht der HEAD, sondern **alle Refs**. Zusatz: **erst landen, dann
löschen** (Memory-Doktrin „Worktree erst löschen wenn grün+gemergt" gilt je Submodul-Branch,
nicht je super-HEAD).

---

### KON49-03 — DIE BERGUNGS-BILANZ: NICHTS VON HEUTE IST VERLOREN (dreifach gemessen)

    (1) ce-SUBMODUL-STORE IST GETEILT (.git/modules/Code/external/comdare-cache-engine)
        -- `worktree remove` loescht das ARBEITSVERZEICHNIS, nicht den Store: alle
        Branches und Commits leben weiter und sind jederzeit landbar.
    (2) fsck ueber ALLE DREI Objektspeicher:
          super          2 dangling -- 11.08. (gelandet) + 12.08. 12:21 (Zwischenstufe
                         des MANUAL_RUN-Commits; Inhalt VOLLSTAENDIG im gelandeten Stand:
                         diff = 0 Zeilen, Gegenprobe am Vorgaenger = 86 Zeilen -> misst)
          ce Haupt-Klon  1 dangling -- 10.08. (PMC-Meta-Meta, laengst gelandet)
          ce GETEILTER   20+ dangling -- juengster 10.08. 14:47; KEIN EINZIGER von heute
          => die Bau-Agenten C/A haben tatsaechlich nichts erzeugt (deckt sich mit den
             Verify-Messungen VOR der Loeschung: "ce-Worktree byte-identisch zu
             development, git status sauber, 0 untracked, 0 stash").
    (3) UNWIEDERBRINGLICH waeren nur UNCOMMITTETE Aenderungen gewesen -- fuer alle drei
        WF11-Worktrees war "sauber" unmittelbar vorher gemessen.
    ⚠️ Das Ergebnis ist GLUECK, nicht Methode: haette Strang D in einem der zehn anderen
    Worktrees gelegen, waere sein Arbeitsverzeichnis weg gewesen.

**NEBENBEFUND aus der Bestandsaufnahme (echte offene Arbeit, kein Verlust von heute):** im
geteilten ce-Store liegen **13 ungelandete Branches** vom 02.–10.08. — darunter drei vom
**10.08.**: `bau/p2-warnstufe-aufteilen` · `bau/p6-lizenz-umsetzung` · `bau/p3-ci-clang-pflicht`
(je 1 Commit; ihre super-Seiten sind gelandet, die ce-Seiten nie). Dazu fünf W2-Branches
(02.08., 4–6 Commits), drei PMC-Branches (06.08.) und `w0a/d2-floor` (09.08., 3 Commits).
**Eigener Aufarbeitungs-Posten** — vor dem main-FF (#19) zu klären: landen oder begründet
ausbuchen.

---

### KON49-04 — VOLLZUG: D GELANDET, C UND A NEU GEBAUT

    GELANDET   ce a99c4a18 (beide Remotes) -- WF11-Strang-D-Wachen.
               Lead-Nachpruefung des Diffs (V1: Bericht ist kein Beweis): 0 allow_failure /
               when:never im Gesamt-Diff, Gegenprobe biss (1x das gewollte `when: always`);
               gitleaks ueber den Push-Inhalt: Koeder biss, Null gedeckt (6 Commits,
               2865 Diff-Zeilen). Pipeline laeuft, Monitor gesetzt (kein Warten).
    NEUBAU     WF12 (`wf_cd576b6e`) faehrt C und A aus den GEBORGENEN Schnitten --
               ohne Wiederholung der Explore-/Design-Arbeit. Zwei Verify-Korrekturen
               sind eingearbeitet:
                 C-P8: die neuen Bissproben-Faelle heissen F27/F28 (F20/F21 sind BELEGT;
                       hoechste vergebene Nummer F26) -- sonst Fall-Namen-Kollision
                 C-P4: der hochzuziehende Block ist :528-532; die SOTA-Schleife :533-534
                       gehoert zur fused-Befuellung und darf NICHT mit hochgezogen werden
               🔴 NEUE WORKFLOW-AUFLAGE: BRANCH-PFLICHT -- Bau-Agenten committen auf einem
               BENANNTEN Branch (nicht detached HEAD), und der Verify muss Branch + Store-
               Pfad SELBST nachmessen und im Ergebnis ausweisen. Damit ist die Arbeit auch
               dann landbar, wenn ein Arbeitsverzeichnis verschwindet.
    PLATTE     2,9 G -> 24 G frei (vier Bauverzeichnisse nach Belegpruefung entfernt:
               git ls-files=0 UND csv/xlsx=0 in allen vieren; elf Worktree-Verzeichnisse).
               Die 2,9 G waren zugleich die Ursache der stummen Tode: der Bau-Strang
               konnte nicht mehr konfigurieren.
