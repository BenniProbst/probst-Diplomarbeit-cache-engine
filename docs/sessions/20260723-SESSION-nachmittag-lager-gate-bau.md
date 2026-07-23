# SESSION 23.07.2026 (Nachmittag) — Lager-Gate-Bau: G2-Stempel-Fenster + B-Seite KOMPLETT

> Fortsetzung von 20260723-SESSION-mittag-neustart-zug-vollbau4.md. Zwei parallele Impl-Agenten
> (Lane A = Impl-S6-P1/Stempel, Lane B = Impl-G3-P2/Lagerhaltung) im geteilten ce-Working-Tree
> mit disjunkten Dateischnitten; Manager landet jede Scheibe granular mit eigenen Wachen-Laeufen.

## 1. GELANDETE SCHEIBEN (alle dual gepusht, je eigener Commit)

**Lane A (G2-Stempel-Fenster, #36 KOMPLETT):** A1 v1->v1.0.0+Guard+Frozen-FP (dd48327f, Smoke
12728 SUCCESS) · A2 Single-Source System+Tooling-X.Y.Z (79f24f6a, Smoke 12742 SUCCESS) · A3
Entry-POD 48B+consteval-Parser (0918b697) · A4 POD 88->136/Layout 5/_MERGE-Arrays = der bewusste
ABI-BRUCH (ad11140d, Smoke 12759 SUCCESS) · A5 CEB-Mess-Array+SHA512 mit Drift-Guard (f2063357)
· A6 AVX10-Feld (53c97072) · A7 .variant-Sidecar (730ebae9). golden-CRC 0xF1C1F26A1232073B ueber
ALLE Scheiben byte-gleich (Byte-Wachen nie aktualisiert).

**Lane B (#46b-Kern KOMPLETT):** B1 Bestandslog-Dokument (351855b8) · B2 Lock/Union-Merge · B3
Factory+SHA512-Index (93b20855; Naht-BEWEIS: Lager-Key == Anatomy-Fingerprint gegen Frozen-Vektor)
· B4 Lifecycle/ETA/Takeover (87cd73a2) · B5 Batch-Planer/Slice-Queue (f8c38ff3) · B6 RAM-Spool
256MB+Writer-Strategy (be250512) · B7 io_uring gegen VENDORED liburing-2.6 (ed174638; UAPI-
Erstfassung nach widerlegtem FortiGate-Befund verworfen) · I1 Iterator-Registrierung+Dedup-Seam
(1e23b9be) · I1b Planer-getriebener Bau gegated (2ad563f0) · I1c CEB-liburing-Link (27455b4e) ·
G5 Pruning-Kern verify_remote_then_prune + PRUNE_ONLY-Treiber (ce f7fa30ef + super 206ae46).

## 2. QUERSCHNITTS-EREIGNISSE

- **PAT-ROTATION erzwungen (#23):** store-Helper verlor den operativen root-PAT nach Server-401;
  kein Vault-Token schreibfaehig -> neuer root-PAT via pve1->Toolbox-Rails (90d, api+rw), API-200
  + Push-Beweis; Token blind in Store+DEV-Vault (nie geprintet). Offen: Alt-Token-Revoke +
  Grundsatzfrage Nicht-root-User.
- **PMC-DOKTRIN (User, §66-N2 + Praezisierung):** pmc:intel reaktiviert; je DEKLARIERTER Lane
  hart (COMDARE_PMC_LANES Default "amd intel" = AND auf Comdare; Fremd-Cluster ueberschreiben ->
  XOR-verschiffbar). Runner-Filter verifiziert (prod1=amd-only, prod2=intel-only). Probe 12757
  pmc:intel+pmc:amd SUCCESS. ce 194dee57 + 57dc0245. Grandchild-Preflight = G4a-Auflage (#37).
- **FortiGate-Klaerung:** Agent-Behauptung "GitHub geblockt" literal widerlegt; Infra-Handover
  Cluster docs/handouts/20260723-handover-infra-fortigate-sni-github-befund.md (194e62e).
- Prozess-Haertungen: ASCII-Selbstcheck-Zeile Pflicht in Paketmeldungen; Mailbox-Bestaetigung
  (msg-IDs) Pflicht; chirurgische CMakeLists-Teil-Commits je Lane-Block.

## 3. RESTWEG ZUM VOLL-BAU-4-TRIGGER

I2 (laeuft, Impl-S6-P1): .fingerprint-Sidecar (FingerprintFn, PFLICHT-Drift-Beweis Facade==dlsym)
+ Facade-Env COMDARE_BESTANDSLOG (getrennte Vars, Endpoint via bestehende minio-Naht) +
variant_sig (A6-Primitive single-source) -> I2b Spool-Naht (Orchestrator) -> G4a EINE Director-
Scheibe (Push-Aktivierung A1-A3 + PMC-Preflight je Lane + measure_out clean-exclude/Artefakt +
PRUNE-Schritt je Perm + planer_block) -> Final-Struktur-Smoke -> lokaler Resume-Skip- +
Hydration-Beweis -> TRIGGER Voll-Bau-4 (Rezept mittag-Doc §5; 24/24 Worker; df-Wachen).
