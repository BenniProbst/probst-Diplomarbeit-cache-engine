# HANDOVER-4 (24.07.2026) — Absturz-/Scrub-Recovery + Agenten-BEREITSCHAFT (nicht gestartet)

> Kontext: Nach Netzwechsel-Resume (23.07. ~16:05) Prozess-Absturz; danach Fremd-Agent-Scrub
> des super-Repos (kamdi-Redaktion, Force-Push main 91897d4->a6af540, development 4494b35->
> d6c06ef, 4 Tags; User-bestaetigt "Aufgeraeumt"). Diese Session: Re-Gruendung + Recovery +
> Bereitschafts-Vorbereitung, DANN PAUSE (Infra-Agent hat einen weiteren Scrub/Wartung vor).

## 1. RECOVERY-STAND (verifiziert)

- **super**: lokal HART auf origin/development d6c06ef8 ausgerichtet (Scrub-Empfehlung; der
  unredigierte Alt-Stand traegt keinen benannten lokalen Ref mehr). origin ist kamdi-frei
  (git grep = 0 Dateien) und traegt den KOMPLETTEN Arbeitsstand (Handover-3, §65/§66+N1+N2).
  **GERETTET:** §66-NACHTRAG-3 (Mapping-Reinheits-Doktrin) war beim Absturz uncommitted und
  fehlte im Scrub-Stand -> aus dem lokalen Tree extrahiert (kamdi-frei verifiziert) und mit
  diesem Commit restauriert.
- **ce**: lokal == origin == bbd5915a, Tree clean. Vom Scrub unberuehrt (Verify-only laut
  Scrub-Bericht; voller ce-Secret-Scan = kommende Infra-Aufgabe).
- **Pipeline 12783 (Vendor-Fix bbd5915a) = SUCCESS** -> der GESAMTE Lager-Gate-Codestand
  (G1+G2 A1-A7+B1-B7+I1/I1b/I1c+G5+I2) ist CI-hart-gruen. Der im Absturz verwaiste
  Verifikations-Strang ist geschlossen.
- Gitlink-Bump super->ce bbd5915a: in DIESEM Commit (stand seit dem Vendor-Fix aus).

## 2. OFFENE SICHERHEITS-/INFRA-PUNKTE (fuer den kommenden Infra-Scrub, NICHT autonom)

1. **github-super ist ALT/UNREDIGIERT** (development dort = 4494b352, prä-Scrub, traegt die
   kamdi-Strings). Mein Push dorthin waere non-FF; Force nur mit je-Repo-GO -> BEWUSST
   NICHT gepusht. => Infra-Scrub-Punkt #1 (github-Seite redigieren/force-synchronisieren).
2. **Server-seitiger Objekt-Purge**: 11 refs/pipelines/* pinnen Alt-Objekte (nur via
   --mirror/Server sichtbar). Scrub-Agent-Empfehlung: Infra ueberlassen/bewusst belassen
   (Purge wuerde CI-Artefakte=Messdaten-Risiko). => Infra-Entscheid.
3. ce + 4 weitere Diplom-Repos: kamdi=0 in HEADs; voller Secret-Scan (ce) = Infra-Verify.
4. #23-Rest unveraendert: Alt-PAT-Revoke (1x403/2x401-Leichen), Nicht-root-User-Frage.

## 3. AGENTEN-BEREITSCHAFT (User-Order: NICHT starten, nur bereithalten)

Beide Impl-Agenten sind mit dem Absturz TOT (Neu-Spawn noetig). Der ce-Tree ist CLEAN ->
keine halbfertigen Agent-Edits verloren gegangen. Bereitliegende Auftraege fuer den Neustart:

**(a) Impl-Agent LANE B — FOLGE-A (Auftrag lag zugestellt, Bau nicht begonnen/verloren):**
Objekt-per-Key-API + Index-Accessor + Presence-Seam, GENEHMIGTER Schnitt: T1 artifact_cache.hpp
additiv PUBLIC object_fetch/store/remove/stat ueber privater mc-Schicht + Binder NEU
bestandslog/artifact_cache_transport.hpp (make_bestand_transport, Dependency-Inversion);
T2 lager_contains(key) public thread-sicher; T3 SEAM-only in NEU bestandslog/lager_presence.hpp
(BinaryIdKeyFn vom Host, make_index_key_fn ueber StaticBinaryView::operator[].binary_id,
make_lager_presence; unaufloesbar=konservativer Miss; Iterator/Facade UNBERUEHRT).
PLUS ERWEITERUNG (Pflicht, §62-N4): BestandEintrag/BinaryKeyPolicy um [d,e,f]-ZELL-KOORDINATEN
als SEPARATE Felder (combo/opt/simd Runtime-Strings; Eindeutigkeit ueber TUPEL, getrennt
geklammert, keine String-Fusion; Dokument-Syntax-Version bumpen; Test: gleiche Perm +
verschiedene simd => ZWEI Eintraege). Grund: Fingerprint traegt per-Zelle-ISA nicht.

**(b) Impl-Agent LANE A — FOLGE-B-ENTSCHEIDUNG (Frage lag unbeantwortet beim Absturz):**
Der Agent hatte verifiziert: Dev-Build enabled ALLE Registry-Varianten -> single-POD-Sig
nicht wohldefiniert; Vorschlag MENGEN-SIGNATUR. **VORBEREITETE ANTWORT (senden beim Neustart):**
"(1) GENEHMIGT — MENGEN-Signatur ueber die drei Enabled-Typlisten: CT via mp_for_each ueber
EnabledPageTypes/EnabledExtensions/EnabledPlatforms, je Achse die enabled Varianten (Name +
build_variant_definition-Properties), PRO ACHSE SEPARAT GEKLAMMERT, deterministisch;
§66-N3-rein (CT ueber Typlisten, kein RT->CT, kein variant, Achsen-Klammern = N3-Punkt 4).
Semantik-Grenze AKZEPTIERT: Gate wirkt auf Driver-CONFIG-Ebene (per-Maschine restringierte
Builds); bei Voll-Enable identische Sig = inert-korrekt. Runtime-march-Deckung NICHT verlangt
(die per-Zelle-ISA deckt der LAGER-Schluessel via Zell-Koordinaten-Erweiterung, s. (a));
opt-in, 3x3-Matrix-Test, Byte-Wachen ohne Update." DANACH: I2b (Spool-Naht) -> G4a
(Katalog Handover-3 §4, + PMC-Preflight #37) -> Final-Smoke.

## 4. WACHEN/UMGEBUNG (bewusster Pause-Zustand)

KEINE Wachen armiert (Infra-Wartung steht bevor; Cron-/df-Wachen erst beim naechsten
Arbeits-Resume neu aufsetzen — Skripte im Transcript/Handover-3 §5). Maschinen ruhig.
PAT lebt (API 200). prod1 109G/prod2 147G frei. Alle Gate-Smokes + 12783 gruen.

## 5. NACH DER INFRA-WARTUNG (Reihenfolge)

1. Remote-Staende NEU verifizieren (falls Infra erneut rewritten hat: fetch + Sichtung +
   reset wie hier; NIE blind pushen). 2. Agenten neu spawnen mit §3-(a)/(b)-Auftraegen.
3. Folge-A + Folge-B landen -> I2b -> G4a + Struktur-Smoke -> Resume-Skip- + Hydration-
   Beweis -> TRIGGER Voll-Bau-4 (Rezept mittag-Doc §5, 24/24, Mess manual). 4. Danach
   Phase 2-5 (mittag-Doc §7).
