# 20260726-matrix-layer-numa-messbeweis-workflow / mess-beweis-rezept (agent a6ca7304)

runId: wf_dc503d77-596
agentId: a6ca7304a5bc7e6f5
label-Zuordnung: mess-beweis-rezept (Prompt-Marker-Deckung 71%)

---

(a) LAUF-REZEPT — kleinster ehrlicher Beweis = GN-11-bare-metal-Rezept auf prod1 (nproc 32)

```
SUPER=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine
PROF=$SUPER/Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_smoke.profile.xml
OUT=$SUPER/Code/measure_out_d03            # Bau- UND Mess-Ziel (dll_dir == measure_out, wie in der CI-Emission)
# 0) P11-Preflight (Pflicht, 1-Thread-Doktrin = Allein-Belegung):
pgrep comdare-messung   # MUSS leer sein -> sonst HARTER ABBRUCH (Praezedenz 21.07. Zombie-Driver)
# 1) FRISCHES Build-Dir (Code/build*, build-i2 sind VOR dc8e1dc7 -> 17-Slot-stale, nicht wiederverwenden):
cd $SUPER/Code && cmake -B build-d03 -G Ninja -DCOMDARE_V32_ENABLE=ON -DCOMDARE_ENABLE_PMC=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build-d03 --target comdare-messung-driver
DRIVER=$SUPER/Code/build-d03/02_messung_driver/comdare-messung-driver
# 2) Profil-Validierung (rein lesend; faengt 18.-Achsen-Drift persistence_target ab):
COMDARE_THESIS_PROFILE="$PROF" "$DRIVER" --validate
# 3) BAU (provision-only, Fenster 0:2 == GN-11-Beleg vom 23.07.):
COMDARE_THESIS_PROFILE="$PROF" COMDARE_GN_OPT=O3 COMDARE_GN_SIMD=no_extension \
  COMDARE_GOLDEN_N_PROVISION_ONLY=true COMDARE_GOLDEN_N_RANGE="0:2" COMDARE_RUN_SOTA=0 \
  COMDARE_BUILD_PARALLEL=24 "$DRIVER" experiment_config "$OUT"
# 4) PRUEF (S3-Gate, kein Neubau, GLEICHES dll_dir):
COMDARE_THESIS_PROFILE="$PROF" COMDARE_GN_OPT=O3 COMDARE_GN_SIMD=no_extension \
  COMDARE_PRUEF_ONLY=true COMDARE_GOLDEN_N_RANGE="0:2" COMDARE_RUN_SOTA=0 "$DRIVER" experiment_config "$OUT"
# 5) MESSUNG (1 Thread: KEIN COMDARE_BUILD_PARALLEL; thread_count=1 steht im Profil):
COMDARE_MEASUREMENT_DROP_URL="https://measure-drop.comdare.local" COMDARE_NFS_DROP_TOKEN="<vault>" \
  COMDARE_THESIS_PROFILE="$PROF" COMDARE_GN_OPT=O3 COMDARE_GN_SIMD=no_extension COMDARE_RUN_SOTA=0 \
  "$DRIVER" experiment_config "$OUT"
# 6) Beleg literal:
find "$OUT" -name measurements.csv -exec sh -c 'echo "$1: $(wc -l < "$1")"' _ {} \;
find "$OUT" -name result.csv | wc -l ; find "$OUT" -name '*.drop.log' -print
```
Profil m3v2_smoke (Ist, heute 16:18 mit-gezogen): 18 permute_axes inkl. `persistence_target`, cap=2,
3 sota_series (A/A/B), workloads `ycsb_a ycsb_c`, working_set 4096, repetitions=1, thread_count=1.
ERWARTUNG (Referenz GN-11 23.07., byte-dieselben Env-Naehte wie die S4-Batch-Jobs emittieren):
8 perm.so, Pruef 8/8, **16 echte Mess-Zeilen** (8 Binaries x 2 Workloads) in measurements.csv +
8 per-Binary result.csv; Zeilen tragen binary_id/ns_per_op/platform=amd@prod1/build_version
(K7b-Stempel `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=<major.minor>`). PMC-Spalten scharf (-DCOMDARE_ENABLE_PMC=ON).
Der statische CI-Job `measure:smoke` ist NICHT der Weg: er ist seit 21.07. deprecated-gegatet
(braucht zusaetzlich COMDARE_STATIC_SMOKE_FALLBACK=true) und faehrt m3_smoke_coverage, nicht m3v2_smoke.

(b) NAS-SCHREIBPFAD + PREFLIGHT (live gemessen, 26.07.)

Ziel-URL: `PUT https://measure-drop.comdare.local/<YYYYMMDD-HHMMSS>/<datei>` (run_stamp je Prozess).
Zwei Sink-Aufrufe: per-Binary `<stem>/result.csv` (iterator :1282) + whole-run `measurements.csv` (profile_run_entry :807).
Kette: OPN-Unbound -> 10.0.60.1:443 SNI-Passthrough -> V80-VIP 10.0.80.226 -> nginx-webdav-Filterpod
(PUT-only, additiv, Pfad-Jail) -> NFS **PR4100 (backup1, 10.0.20.241) Cluster_NFS/cache-engine-experiment**.

Preflight-Liste (Stand jetzt, literal):
- DNS `measure-drop.comdare.local -> 10.0.60.1` OK; `curl https://.../` = **HTTP 403 in 0,031 s** (UP, write-only, wie designt).
- `ping 10.0.20.241` (PR4100) = 0% loss, 0,33 ms.
- `mc` vorhanden (/usr/local/bin/mc); `minio.prod.comdare.de/minio/health/live` = 200 (fuer diesen Lauf NICHT gebraucht).
- **Token FEHLT lokal** (`env | grep COMDARE_NFS_DROP_TOKEN` = 0 Treffer) = der EINZIGE echte Blocker.
  Quelle laut Cluster-Handoff 12.07.: k8s-Secret `measure-drop-token` (ns `measure-drop`, Keys
  `COMDARE_NFS_DROP_TOKEN` + `user`=measure) — via `Cluster/keys/cluster` -> root@10.0.10.201 (pve1) -> kubectl.
  E-14: neue backup1/backup2-Credentials liegen im Cred-Vault — ziehen, NIE raten, NIE ins Log/argv.
- Auth-Falle: **Basic `measure:<token>`**, NICHT Bearer (Bearer gab 401; Beleg Pipeline 11401). Der ArtifactCache
  loest das ueber 0600-curl-config; per Hand-Probe `-u measure:$TOKEN --netrc-file`/`-K` verwenden.
- Mount-Falle: **kein POSIX-Mount** (User-Entscheid A). prod1 hat nur `/mnt/backup2-nfs` (backup2 .242, nur
  git-bundles) und ein LEERES `/mnt/backup1-prescrub`. PR4100 auf prod1 NICHT mounten — prod1 ist V60-Runner-Host,
  und V60 darf Cluster_NFS nie lesen. Landungs-Beweis daher rein per HTTP: erster PUT 201, zweiter PUT
  desselben Pfades **409** = Datei liegt auf dem NAS (write-only-Doktrin, GET ist 403).
- mc-/Endpoint-Falle (nur relevant falls Ebene B mitlaeuft): `COMDARE_MINIO_ENDPOINT` muss den mc-**ALIAS** tragen,
  nicht die S3-URL. Fuer diesen Lauf Ebene B bewusst AUS lassen -> drop-only ist gueltig gebunden
  (`if (!artifact_cache->inert())`, sink_measurement gatet nur auf drop_enabled).
- `COMDARE_STORAGE_CACHE=true` ist NUR der CI-Wrapper (.gitlab-ci.yml :570); bare-metal liest der Driver
  `ArtifactCache::from_env()` direkt -> die zwei Drop-Variablen genuegen.
- M32-Doppel-Persistenz (Pflicht, nicht optional): zusaetzlich `measurement/<YYYYMMDD-HHMMSS>-d03/` im super-Repo
  anlegen, CSVs kopieren, `git add -- measurement/` (die .gitignore-Negation `!measurement/**/*.csv` macht sie
  trackbar), commit + dual push development. `measurement/` existiert heute noch NICHT -> das wird der DoD-6-Erstbeleg.

(c) ZEIT + RISIKEN

Zeit (prod1, 32 Kerne): Build-Dir+Driver 15-25 min · --validate <1 min · BAU 8 .so O3 10-20 min ·
PRUEF 1-2 min · MESSUNG 16 Zeilen 5-15 min · Drop+git 5 min = **45-70 min brutto**, Puffer 2 h.
Risiken:
- R1 stale Build-Dirs (build/, build-i2, build-f12i) sind vor dc8e1dc7/fcd95a44 (17->18 Slots) -> Wiederverwendung
  ergaebe falsches Gruen (POD/binary_id-Drift). Deshalb hart neues build-d03.
- R2 Token nicht beschaffbar -> Drop bleibt inert und der Lauf laeuft trotzdem gruen durch (Fehlerklassen-Doktrin
  "misst weiter") = CSV lokal, aber NICHT auf dem NAS. Token daher VOR Schritt 5 klaeren, sonst ist das Frist-Ziel verfehlt.
- R3 Fremder/Zombie-Driver oder parallele CI-Mess-Batch auf prod1 -> 1-Thread-Doktrin gebrochen; resource_group
  greift nur in CI, bare-metal schuetzt nur der pgrep-Preflight.
- R4 m3v2_smoke wurde heute mit-gezogen; falls --validate faellt, ist das ein 18-Slot-Profil-Bug, kein Infra-Problem
  -> dann base_pilot.profile.xml als Rueckfall (kleiner, gleiche Naht), Abweichung im Beleg benennen.
- R5 measurements.csv < 16 Zeilen oder 'failed'-Zellen -> ehrlich so melden (nie Nullen), Log neben der CSV mitliefern.
- R6 409 beim ERSTEN PUT waere ein run_stamp-Kollisions-Indiz (fremder Lauf im gleichen Sekundenordner) -> pruefen, nicht ignorieren.

(d) HEUTE ABEND vs MORGEN FRUEH

Heute abend (26.07., zwingend, ~2 h): (1) Token aus k8s-Secret/Vault ziehen + Hand-PUT-Probe gegen einen eigenen
Datums-Pfad -> 201, Wiederholung -> 409 (das ist der NAS-Beweis, unabhaengig von der Messung); (2) build-d03 +
--validate; (3) die 3-Schritt-Kette BAU/PRUEF/MESS drop-scharf fahren; (4) `measurement/<ts>-d03/` committen +
dual push. Nach diesem Block liegt die CSV auf PR4100 UND in git — Frist erfuellt, unabhaengig von CI.
Morgen frueh (27.07., nur noch Absicherung, nichts Tragendes): (5) Re-Verifikation der Drop-Landung per
409-Probe auf die konkreten Datei-Pfade + Zeilen-Zaehlung erneut literal; (6) optional CI-Spiegel-Lauf
(planer:delegate/COMDARE_RUN_MEASURE + COMDARE_PERSIST_MEASUREMENTS=true, Token id=54) als zweiter,
maschinen-unabhaengiger Beleg; (7) optional appendix-generator ueber das WIDE-Aggregat fuer Anhang A.
Begruendung der Reihenfolge: der einzige unbekannte Blocker ist der Drop-Token — der muss heute fallen,
weil ein Nachtlauf ohne Token still lokal-only endet und Montag dann kein NAS-Beleg existiert.
Selbstcheck: ASCII-only geprueft (kein Nicht-ASCII in dieser Antwort); alle Live-Werte aus eigenen Kommandos, nichts geraten.
