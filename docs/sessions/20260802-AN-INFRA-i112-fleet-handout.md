# AN INFRA (BRING, E-20) — I112-Fleet-Handout, aktualisierte Fassung nach Welle-2b-Nachbesserung (02.08.2026)

> NUR ZUR KENNTNIS an Infra. Quelle: docs/infra/I112_RUNNER_FLEET_IST_SOLL_ALLE_ARCHITEKTUREN.md (super dev, Welle-2b-Landung). Cluster-Repo bleibt diplomseitig read-only.

INFRA-HANDOUT (AKTUALISIERTE FASSUNG nach Review-Nachbesserung; Cluster-Push ist Lead-only, BRING erfolgt nach Lead-Push). Zielpfad: /home/comdare/Projekte/Cluster/docs/sessions/2026-08-02-HANDOUT-diplom-an-infra-runner-fleet-jitter.md (E-20-Kanal; Namens-Konvention folgt 2026-07-26-HANDOUT-diplom-an-infra-runner-concurrency-zwei-modi.md). AENDERUNGEN GEGENUEBER DEM ENTWURF: node7 auf K118f/K118g-Stand (Abschnitt 1 + Rueckfrage 4), prod2-HW-Rueckfrage GESTRICHEN (per VOLLZUG-Doc geklaert; Rueckfragen neu durchnummeriert 1-3), Doc-Pfad auf den neuen Dateinamen, riscv64-Hinweis zum nativen Bau in Abschnitt 2, Quellenliste um K118f/K118g/VOLLZUG ergaenzt. VOLLTEXT:

# DIPLOM -> INFRA (2026-08-02): Runner-Fleet-Nachaktivierung, Tag-Schema, Poll-Jitter (E-19)

> Absender: Diplomarbeits-Strang. Anlass: Owner-Punkt E-19 ist seit 02.08. PFLICHT.
> Unser Gegenstueck: super `docs/infra/I112_RUNNER_FLEET_IST_SOLL_ALLE_ARCHITEKTUREN.md` (Ist-Soll-Matrix ueber alle Architekturen, Stufe 1).
> Secret-frei. Wir haben NICHTS am Cluster veraendert (read-only-Doktrin) und KEINEN Admin-API-Call abgesetzt.
> Stand dieser Fassung: eingearbeitet sind eure Docs bis einschliesslich K118g (~16:25) sowie euer O-4a-VOLLZUG vom 27.07.

## 0 Was wir bewusst NICHT getan haben
`GET /api/v4/runners/all` ist admin-only. Mit unseren Tokens haette der Aufruf 403 oder eine gefilterte Liste geliefert -- ein leeres Ergebnis als 'Ist' zu fuehren waere der gefaehrlichste Fehler in dieser Sache. Unsere Ist-Spalte ist deshalb durchgehend mit 'von Infra zu bestaetigen' markiert und nur aus (a) unseren CI-Job-Traces und (b) euren eigenen Reports im Cluster-Repo unterlegt. Ihr habt die Hoheit; wir bitten um Bestaetigung oder Korrektur.
Innerhalb eurer Reports gilt bei uns jetzt ausdruecklich: **der juengste Bericht zu einem Host gewinnt.** Eine Vorfassung dieses Handouts hatte node7 allein nach K118d gefuehrt und eure spaeteren Docs uebersehen -- korrigiert.

## 1 Auftrag 1 -- Fleet-Nachaktivierung (Owner-Wortlaut)
> "Laufen weiterhin alle im cluster geplanten gitlab runner ueber alle Architekturen nach der Cluster gitlab runner Beschreibung? Ansonsten aktiviere das bitte nachtraeglich"
Owner-Nachtrag 02.08.: "heute kommt noch RISC-V und ein macOS M1 und macOS x86 dazu."

Unser Bild (aus euren Reports uebernommen, bitte pruefen):
- prod1 id16 / prod2 id17: online, von uns heute per Job-Trace bestaetigt (gitlab-runner 19.1.1). Tags laut eurer Voll-Erhebung 26.07.: id16 `prod, baremetal, amd, amd64, avx2, avx512(+12 sub-flags), x86_64`; id17 `prod, baremetal, intel, amd64, avx2`. Modi `normal` = 3/10 bzw. 2/12.
- node7 id4 (arm64-linux): **wir fuehren ihn nicht mehr als hart ausgefallen.** Nach K118f habt ihr den Root-Cause-Kandidaten `samba-sysvol-sync` (kubectl-exec-Tar-Stream, alle 15 min aus der node7-User-crontab) identifiziert und auf Owner-Anweisung alle 14 Backup-Jobs reversibel abgeschaltet; nach K118g `:9` ueberlebt der Node seither 23+ min (vorher 9-12) und ist wieder zugreifbar, Beobachtung laeuft (#536). Wir uebernehmen dabei ausdruecklich eure eigene Einschraenkung: der Zusammenhang ist stark indiziert, nicht bewiesen (kein OOM-Kill im Journal des Crash-Boots). Offen ist fuer uns nur noch, ob die Stabilitaet ueber Stunden haelt -- und ob die arm64-Lane damit dauerhaft traegt oder der von euch selbst geflaggte zweite arm64-Linux-Runner (#394/#78) noetig wird.
- node8 id5 (riscv64): euer K118c-Nebenbefund sagt, node8 ist online (10.0.60.208, :22) entgegen Doku/Board. Es fehlt aus unserer Sicht nur ein `riscv64`-Tag + CI-Ansprechbarkeit. Bitte bestaetigen/aktivieren.
- node6 id3 (macOS M1) und node5 id2 (macOS Intel): laut Voll-Erhebung 26.07. stale; node5 haengt laut K118b/K118c am V10-Egress/Port-Thema (nach K118e ist die CP-Allowlist beider OPN paritaetisch gesetzt). Bitte nach Recovery registrieren + taggen.
- Ausserdem offen aus eurer eigenen Liste: id14 `prod-k8s-x86-main` (tot seit 06-22 -- deregistrieren oder reaktivieren?), id6-id9 (pve1/pve2/node3/node4, stale).

## 2 Auftrag 2 -- Tag-Schema bestaetigen (Vorschlag, keine Vorgabe)
| Zelle | Vorschlag | Bemerkung |
|---|---|---|
| RISC-V Linux | `riscv64` (+ `linux`) | analog zur `arm64`-Praezedenz |
| macOS Apple Silicon | `macos-arm64` | OS-Familie + ISA in EINEM Tag |
| macOS Intel | `macos-x86-64` | Bindestrich-Form, nicht `macos-x86_64` |
Bitte EINE Schreibweise festlegen (wir haben die Bindestrich-Form gewaehlt und ziehen bei abweichender Infra-Schreibweise unsere Doku nach, nicht umgekehrt).
WICHTIG -- Tag-Disjunktheit: Nach dem Vorfall vom 27.07. (id53/54/55 trugen `baremetal` und griffen Linux-Jobs ab; `run_untagged=false` half prinzipiell nicht) bitten wir darum, dass die neuen macOS-/RISC-V-Runner KEINE bestehende Lane-Semantik mittragen -- insbesondere kein `arm64`, kein `baremetal`, kein `prod` auf macOS-Runnern.
CI-Seite: Wir ziehen `tags:`/Jobs fuer die neuen Zellen ERST nach eurer Vollzugs-Meldung nach (sonst pendende Jobs / rote Pipelines gegen nicht existente Runner).
Eine Selbst-Auflage auf unserer Seite, damit ihr sie kennt: sobald node8 einen `riscv64`-Tag traegt, koennte unser Build-System dort **nativ** riscv64-Binaries erzeugen (unsere `platform_detection.cmake` erkennt die ISA bereits), waehrend unsere Mess-Achse `target_isa` die ISA noch nicht fuehrt. Solche Artefakte waeren bei uns lager-/stempelseitig nicht zuordbar. Wir schalten einen riscv64-CI-Job deshalb nur opt-in und ohne Lager-Rueckschrieb -- analog zu `build:arm64-smoke`. Das ist **kein** Grund, den Runner nicht zu taggen; es ist nur unsere Reihenfolge.

## 3 Auftrag 3 -- Poll-Verhalten (Owner-Soll woertlich)
> "alle 2+rand(0.0 ... 1.0) Sekunden nach neuen jobs pollen"
Also Grund-Intervall 2 s + gleichverteilter Jitter < 1 s je Runner, damit die Runner nicht im Gleichtakt pollen.
Die Umsetzung liegt bei euch -- wir schreiben ausdruecklich nichts vor. Unser Kenntnisstand (unverifiziert): `check_interval` in der Runner-`config.toml` ist ganzzahlig, ein Sub-Sekunden-Jitter waere dann nicht nativ konfigurierbar. Bitte gegen die offizielle Runner-Doku fuer die Ist-Version verifizieren (auf beiden prod-Hosts laut Trace: gitlab-runner 19.1.1).
Gebeten wird um: (a) Aussage, ob die Owner-Formel nativ abbildbar ist; (b) falls nein, die von euch gewaehlte Naeherung (z. B. gestaffelte ganzzahlige Intervalle je Runner) mit Begruendung; (c) in beiden Faellen ein literaler `config.toml`-Auszug der wirksamen Poll-Einstellung je Runner plus Reload-Beleg. Secret-Hinweis: die Datei traegt `cache.s3`-Credentials -- bitte nur die Poll-Zeilen zitieren, nie die ganze Datei.

## 4 Rueckfragen
1. Welche Fassung ist die massgebliche 'Cluster gitlab runner Beschreibung'? Auffindbar sind (a) `20260225-00-00-003061-staged-build-pipeline-12runner-layer-assignments.md` (+ `...-003059-exotic-runner-macos-gitlab-dbfix.md`, Feb 2026) und (b) eure Voll-Erhebung `2026-07-26-INFRA-runner-matrix-DONE.md`. Ohne diese Festlegung ist 'alle geplanten Runner' nicht pruefbar.
2. Stehen prod1/prod2 heute weiterhin auf `normal` (3/10 bzw. 2/12)? Wir melden uns vor dem Voll-Bau/der Messung separat wegen `heavy`.
3. node7 (#536): haelt die Stabilitaet nach der Backup-Abschaltung ueber Stunden -- und bleibt die arm64-Lane damit auf node7, oder kommt der zweite arm64-Linux-Runner (#394/#78)? (Dies ersetzt unsere frueher gestellte Frage 'Wiederherstellung, Ersatz oder Abschreibung?' -- sie ist durch K118f/K118g teil-beantwortet; Abschreibung steht fuer uns nicht mehr im Raum.)

*Zurueckgezogen: unsere frueher gestellte Rueckfrage zur prod2-Hardware (i9-12900K vs. i9-14900KS). Ihr habt sie am 27.07. bereits beantwortet (`2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md`, Live-`lscpu`: `12th Gen Intel(R) Core(TM) i9-12900K`, family 6 / model 151 / stepping 2). Unsere aeltere Matrix war pre-RMA-stale; diplomseitig ist der Wert nachgezogen. Danke -- kein Handlungsbedarf bei euch.*

## 5 Was wir mit eurer Antwort tun
Eure Rueckmeldung fuellt die Nachtrags-Sektion von `docs/infra/I112_RUNNER_FLEET_IST_SOLL_ALLE_ARCHITEKTUREN.md`. Diese Nachtrags-Stufe ist ausdruecklich KEIN Gate fuer unseren Voll-Bau -- der laeuft auf prod1/prod2. Wir wollen nichts blockieren, sondern den Owner-Punkt E-19 sauber und ehrlich schliessen.

## 6 Belege/Quellen dieses Handouts
- Unsere CI-Job-Traces 02.08. (prod1 13:20:08Z, prod2 13:23:24Z + 08:06:27Z), gitlab-runner 19.1.1.
- Cluster-Repo (read-only gelesen): `2026-07-26-INFRA-runner-matrix-DONE.md` (Abschnitt A), `2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md`, `2026-07-27-INFRA-win-runner-untagged-fix-DONE.md`, `2026-07-27-INFRA-P4-windows-runner-git-online-VOLLZUG.md`, `2026-07-27-INFRA-node7-diskgc-runner-contention-B1-VOLLZUG.md`, `2026-08-02-K118b-NACHMITTAG-BEFUNDE-node5-V10EGRESS-OFFENE-ARBEIT.md`, `2026-08-02-K118c-node5-RECOVERY-RUNBOOK-drei-wege.md`, `2026-08-02-K118d-SWEEP-6-DIAGNOSEN-node7-AUSFALL-V10-POLICY-KORREKTUREN.md`, `2026-08-02-K118f-node7-ROOT-CAUSE-sysvol-sync-backups-abgeschaltet.md`, `2026-08-02-K118g-KOORDINATION-offene-straenge-priorisiert.md`.
- Owner-Wortlaute: super `docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md:91-94` und `docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:13`.

**Ende Handout. Antwort bitte als Cluster-Session-Doc + Push (wir ziehen read-only nach).**
