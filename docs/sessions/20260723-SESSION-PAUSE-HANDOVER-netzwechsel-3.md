# PAUSE-HANDOVER Netzwechsel-3 (23.07.2026 ~15:50) — KALTER RESUME-STAND Lager-Gate

> Gesichert VOR Netzwechsel (User-Auftrag: reicher Zwischenstand, Netz evtl. instabil).
> Kontext-Kette: mittag-Doc (Neustart-Zug §1-§7) -> nachmittag-Doc (Lager-Gate-Bau) -> DIESES.
> Ledger-Autoritaet: §65 (Storage-Doktrin), §66 (+N1 Frist, +N2 PMC+Praezisierung, +N3 Mapping-Reinheit).

## 1. HARTE STAENDE (alle dual gepusht: origin=gitlab.comdare.local + github)

- **ce development = 27455b4e** (Kette seit 2f756da1: dd48327f A1 · 351855b8 B1 · 87cd73a2 B4 ·
  f8c38ff3 B5 · be250512 B6 · 8011beb6 Push-Stand A1+B1/B2 · 93b20855 B3 · 730ebae9 A7 ·
  79f24f6a A2 · 1e23b9be I1 · 0918b697 A3 · f7fa30ef G5 · ad11140d A4(ABI-Bruch) · 2ad563f0 I1b ·
  194dee57+57dc0245 PMC · f2063357 A5 · 27455b4e I1c). ed174638 = B7-liburing.
- **super development = e374516** (206ae46 PRUNE_ONLY-Treiber · 357c3f3/dcd79f2/323a142/9ff7ac3
  Gitlinks · e374516 Nachmittags-Doc+PMC-Ledger). **Cluster = 194e62e** (FortiGate-Handover).
- **UNCOMMITTED im ce-Tree (ABSICHTLICH, Impl-S6-P1 arbeitet):** I2-Teil-1-Plumbing
  (build_orchestrator.hpp FingerprintFn/write_fingerprint_sidecar + iterator bestand_fingerprint_fn)
  + Teil 2/3 in Bau. NICHT wegwerfen, NICHT blind committen — Paketmeldung abwarten (s. §3).
- CI: ALLE Gate-Smokes SUCCESS (A1=12728, A2=12742, A4=12759); PMC-Probe 12757 beide Jobs
  SUCCESS; 12720/12723/12724 gruen; laufende Push-Pipelines fuer juengste ce-Pushes normal.

## 2. LAGER-GATE-FORTSCHRITT (§66; Blocker fuer Voll-Bau-4 = Task #22)

FERTIG: G1 (#27 ✔ inkl. 199-Heartbeat-Trace-Beweis) · G2-Stempel-Fenster KOMPLETT (#36 ✔,
A1-A7, golden-CRC 0xF1C1F26A1232073B ueberall byte-gleich) · B-Seite KOMPLETT (B1-B7+I1+I1b+I1c)
· G5-Kern (Pruning-Bibliothek+PRUNE_ONLY-Treiber; #35 Rest = Emission+Hydration-Beweis).
IN BAU: **I2** (Impl-S6-P1, s. §3). DANACH: I2b (Spool-Naht Orchestrator, klein) -> **G4a**
(EINE Director-Scheibe, s. §4) -> Final-Struktur-Smoke -> lokaler Resume-Skip- + Hydration-
Beweis -> TRIGGER Voll-Bau-4 (Rezept mittag-Doc §5: NUR COMDARE_BUILD_GOLDEN_N=true, 24/24
Worker, Mess-Batches when:manual; Abnahme-Kriterien mittag-Doc §4 inkl. GN_DECISION=skip).

## 3. IN-FLIGHT: I2 bei Impl-S6-P1 (Pausen-Anweisung: FERTIGSTELLEN + FREEZE, nichts Neues)

Auftrag (msgs 0f69b20a/f1dfcd71/56e407f3/205d7d27/08046cf0): Teil 1 ✔ (Plumbing, uncommitted).
Teil 2 = Facade profile_run_facade.cpp: FingerprintFn-Closure (compose organ/system/mess/merge-
Zeilen wie Emitter -> ctsha512) + Env-Verdrahtung **COMDARE_BESTANDSLOG=true (Master) +
_DOC_KEY/_OWNER_UUID/_MASCHINE diskret; Endpoint via bestehende minio-Naht, KEINE Dopplung**.
Teil 3 = variant_sig in **REGISTRY-TABELLEN-Form**: CT-Tabelle EINMAL ueber Registry-Typlisten
instanziiert (build_variant_definition<PT,SE,HW> -> compose_variant_signature je Kombination),
Facade-Lookup per Flag = runtime->runtime ueber vorberechnete Werte. ZIRKULARITAETS-VERBOT:
Expected-Seite NIE aus der (alten) DLL/deren Makro (sonst ISA-Mismatch prinzipiell unentdeckbar);
Stored-Seite bleibt A7-.variant-Sidecar. Ausweich (c): Gate bleibt OFF statt Zweitwahrheit.
PFLICHT-BEWEISE im Paket: (a) Drift: Facade-Fingerprint == dlsym-sha512_line EINER real
gebauten DLL; (b) §66-N3-Mapping-Reinheit explizit ausgewiesen (kein variant, kein RT->CT);
(c) Byte-Wachen OHNE Update; (d) voller ctest; (e) ASCII-Selbstcheck; (f) Achsen getrennt
geklammert in Signaturen. **Kalter Resume ohne lebenden Agenten:** Tree-Diff sichten (nur
orchestrator/iterator/facade+neue Tabelle erwartet), Auflagen oben als Abnahme-Matrix nutzen;
bei Unklarheit Teil-3-Zweifel -> (c)-Rueckbau, Teil 1+2 einzeln landen.

## 4. G4a-AUFLAGEN-KATALOG (naechste Scheibe NACH Pause, experiment_plan_director.hpp, EIN Commit)

(1) P-A Push-Aktivierung: append_forward_var_literal("COMDARE_STORAGE_CACHE") @:724; source
comdare_storage_activation.sh in BEIDEN Batch-Emissionen nach Submodul-Prolog; TRIES-Deckel
guarded. (2) PMC-PREFLIGHT je Lane (#37): measure-Batch prueft VOR erster Messung hart die
eigene PMU (Intel-Lane nur nach intel-Probe usw.), folgt der Lane-Menge der Emission.
(3) P-C measure_out (#33): GIT_CLEAN-Exclude + Artefakt-CSV-Glob + Pfad-Pins nachziehen.
(4) PRUNE-Schritt je Perm am Batch-Ende (#35-Anschluss, PRUNE_ONLY-Aufruf, opt-in).
(5) planer_block-Reservierung (Integrations-Doc I2-Restpunkt). DANACH: Struktur-Smoke-Neubeweis
PFLICHT (Emitter beruehrt) + Byte-Determinismus-Tests nachziehen.

## 5. AGENTEN + WACHEN (Resume-Anleitung)

- **Impl-S6-P1** (blau, Opus): I2 fertigstellen->FREEZE (Pausen-Anweisung 08046cf0). Nach Resume:
  Paketmeldung abholen/anfordern; bei totem Agenten §3-Kaltweg.
- **Impl-G3-P2** (orange, Opus): STANDBY, nichts offen; naechster Slot = Hydration-Smoke nach G4a.
- **Wache b5nxgn31k** (ResumeWorker-Cron, persistent, 10min-Poll via pve1-SSH): wirft nach
  Netzwechsel ggf. SSH-FAIL-Alarme -> bei Resume TaskStop + NEU armieren (Skript im Transcript;
  Kern: EXISTS+last_enqueue von cron_job:default:sidekiq_concurrency_limit_resume_worker).
- Keine offenen Pipeline-Watcher (alle terminal). Maschinen ruhig (kein Batch; 12713 gecancelt
  + Waisen beidseitig gesweept; sudo-Sweep `sudo -n /usr/local/bin/comdare-sweep-orphans` auf
  BEIDEN Maschinen installiert; prod1-Root-Weg: ssh -i cluster admin-management@localhost sudo).

## 6. SICHERHEIT (Blind-Handling, NIE printen)

- PAT ROTIERT (23.07. ~14:15): root-ci-rotation-20260723 (90d, api+rw), im git-credential-store
  UND DEV-Vault (Abschnitt "PAT-Rotation 2026-07-23" am Ende). Alt-Tokens (1x 403-read-only,
  2x 401-tot) NOCH NICHT revoked -> #23-Rest. Grundsatzfrage an User offen: eigener
  Nicht-root-GitLab-User (nur root+project_288_bot existieren).
- Falls nach Netzwechsel Push-Auth stirbt: store-Helper kann Eintrag nach Server-401 loeschen;
  Re-Seed: Token blind aus DEV-Vault (grep -oE 'glpat-[A-Za-z0-9._-]{15,}' | tail -1 — der
  NEUSTE steht am ENDE) -> git credential approve. NIE Werte ausgeben.

## 7. PLATZ/INFRA-STAND

prod1 109G frei (Cleanup: 24G Scratchpad + 33G root erledigt; /srv/gluster tabu; Runner-Bestand
30G war lebend, nach 12713-Cancel teilweise obsolet — bei Bedarf NACH Gate pruefen). prod2 147G.
measure-drop UP. COMDARE_PMC_LANES="amd intel" (ce-Default); COMDARE_PROD2_AVAILABLE=true
(Projekt-Var 286, inert seit 57dc0245). Coldstore /var/mnt/coldstore NICHT gemountet (Option tot).

## 8. NACH DER PAUSE (Reihenfolge)

1. I2-Paket abnehmen (Matrix §3) -> Commit -> Dual-Push -> ggf. Struktur-Smoke (I2 ist
   emitter-neutral geplant; Smoke erst nach G4a noetig). 2. I2b (Spool-Naht). 3. G4a (§4) +
   Smoke. 4. Resume-Skip-Beweis lokal (Doppellauf, GN_DECISION/Skip-Zaehlung) + Hydration-
   Smoke (G3-P2). 5. TRIGGER Voll-Bau-4 + df-Wachen beide Maschinen + Cron-Wache neu.
   6. Danach Phase 2-5 der Gesamtabfolge (mittag-Doc §7).

## 9. ADDENDUM SOFORT-PAUSE (~16:05): I2 UNFERTIG im Tree pausiert

Die Pause kam VOR der I2-Paketmeldung. IST-SNAPSHOT des ce-Working-Trees (uncommitted,
Basis 27455b4e; 5 Dateien, 132+/3-):
  M build_orchestrator/build_orchestrator.hpp        (I2-T1: FingerprintFn/write_fingerprint_sidecar)
  M experiment_tree/cache_engine_builder_iterator.hpp (I2-T1: bestand_fingerprint_fn-Durchreiche)
  M profile_facade/lazy_adhoc_source_gen.hpp          (I2-T2/T3 IN ARBEIT — vermutlich Emitter-/
  M profile_facade/profile_run_entry.hpp               Registry-Tabellen-/Facade-Naehte, Stand
  M tests/unit/test_lazy_adhoc_source_gen.cpp          UNVERIFIZIERT — nicht abgenommen!)
KALTWEG bei Resume: erst Impl-S6-P1-Kurzmeldung suchen (Mailbox/Transcript); sonst Diff der 5
Dateien gegen die §3-Abnahme-Matrix sichten. Teil-1-Anteile (orchestrator/iterator) sind vom
Agenten voll-build-verifiziert gemeldet; die profile_facade-Anteile sind MITTEN in Teil 2/3 —
im Zweifel: facade-Anteile zurueckstellen (git stash/Neubau nach Matrix), T1 einzeln abnehmen.
NICHTS blind committen, NICHTS wegwerfen. Wachen bei Pause beendet (Cron-Wache b5nxgn31k
gestoppt — bei Resume NEU armieren, §5).

## 10. ADDENDUM-2 (~16:15): I2 DOCH NOCH GELANDET — Tree CLEAN, Pause final

Die I2-Paketmeldung kam Sekunden nach der Sofort-Pause -> abgenommen und committet als
**ce d8ead0a8** (super-Gitlink folgt im selben Commit wie dieses Addendum), dual gepusht.
§9-Kaltweg damit OBSOLET: ce-Working-Tree ist CLEAN, beide Agenten FROZEN/Standby.
I2-ERGEBNIS: .fingerprint-Sidecar-Produktion DRIFT-BEWIESEN (Makrotext-Parse == Provider-
sha512) hinter COMDARE_BESTANDSLOG=true; ZWEI (c)-Vertagungen mit dokumentierten
Architektur-Waenden (KEINE Zweitwahrheit gebaut):
  (A) Bestandslog-KONSUM (transport/present) braucht: generische ArtifactCache-Objekt-
      per-Key-API + public LagerRunState-Index-Accessor + view_index->binary_id-Aufloesung.
  (B) variant_sig-Aktivierung braucht: per-Zelle-Variant-Key beim BUILD aus dem enabled
      Wrapper emittiert (einzige Stelle mit dem Typ) — KEINE Runtime-String->Typ-Ableitung.
BEIDE = eigene Folge-Scheiben NACH der Pause, VOR G4a einplanen (A entsperrt den echten
Lager-Konsum im Voll-Bau-4; B aktiviert das ISA-Mismatch-Gate fuers Cross-Maschinen-Lager).
Neue Reihenfolge nach Pause: Folge-A -> Folge-B -> I2b (Spool) -> G4a (§4) -> Smoke ->
Beweise -> TRIGGER.
