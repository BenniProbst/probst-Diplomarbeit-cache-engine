# DOSSIER #188-4c-0b — is_original-Includes gaten (CI-Unblock für das Known-Compositions-Gate)

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `7653530`).**
**Problem (verifiziert):** 6 Paper-Allocator-Wrapper inkludieren UNGEGATED ihren auto-generierten
is_original-Header: `axes/alloc/axis_06_allocator_{dlmalloc:29,jemalloc:30,lrmalloc:31,mimalloc:37,rpmalloc:30,snmalloc:31}.hpp`
→ `<topics/allocator/axis_06_allocator/legacy_code/paper_aNN_*_is_original.hpp>`. Der Header entsteht NUR wenn
der Codegen läuft (CMakeLists:1142 `COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION` + Helper + **ext/-Sentinel** —
ext/ ist Submodul, auf CI leer → Codegen skippt still, Z.1140). Design-SOLL (CMakeLists:1122): „Bei OFF: kein
Codegen, **kein Mixin-Include** — is_original_module()=false". Die Wrapper verletzen das → auf CI strukturell
unkompilierbar; CI-Job contract:conformance (Pipeline 7429+7431) bricht beim dyndep-Scan (fatal error).

## Auftrag (NUR dieser Fix — kein 4c-i, keine anderen Achsen)
1. In ALLEN 6 Wrapper-Headern: den is_original-Include + die davon abhängige Mixin-Verwendung
   design-konform gaten. GATE-WAHL (verifizieren, nicht raten): Untersuche `concepts/axis_06_allocator_original_code_mixin.hpp`
   + einen generierten Header-Erzeuger (`cmake/is_original_codegen.cmake`, comdare_register_paper_wrapper) —
   setzt der Codegen ein Define (z.B. via Flags/configure)? FALLS ein solches Define existiert → nutzen.
   FALLS NICHT: neues, EINHEITLICHES Gate einführen: CMake definiert `COMDARE_A06_IS_ORIGINAL_CODEGEN=1`
   compile-weit NUR im Codegen-aktiv-Fall (kleiner CMakeLists-Zusatz im 1142er-Block bzw. dessen else) und
   die 6 Header nutzen `#if defined(COMDARE_A06_IS_ORIGINAL_CODEGEN)` um Include+Mixin; im else-Zweig
   MUSS der Wrapper voll funktionsfähig bleiben mit `is_original_module()==false`-Semantik (das
   original_code_mixin-Konzept hat laut Design den OFF-Pfad — am Mixin-Header ablesen, exakt dessen
   Mechanik nutzen; ggf. existiert schon ein Null-Mixin/Default).
2. Prüfe per grep, ob WEITERE Achsen-Topics (nicht nur alloc) dieselben ungegateten legacy_code-Includes
   tragen — falls ja, gleiches Muster anwenden und im Bericht listen.
3. `.gitlab-ci.yml` contract:conformance: das Flag `-DCOMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION=ON`
   WIEDER ENTFERNEN (Sackgassen-Fix, Kommentar von 7653530 mit-anpassen auf die neue Gate-Wahrheit).
4. TABU: modules/**, ext/**, golden, Registry-mp_list, tests/unit/CMakeLists.txt (Integrator), KEINE
   Verhaltensänderung für Builds MIT Codegen (Windows-lokal). Kein git. Keine $null-/~NNNNN-Artefakte.
5. Bericht: (a) Gate-Mechanik-Befund (Define vorhanden/neu), (b) je Datei die Änderung, (c) weitere
   Topics-Funde, (d) Risiken. Increment-Tag `#188-4c-0b (2026-07-02)`.
