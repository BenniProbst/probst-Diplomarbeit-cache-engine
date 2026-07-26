# CHUNK 22/30 — Extraktion (chronologisch)

Quelle: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/tk_22.txt` (2142 Zeilen, vollständig gelesen). Zeitraum: 19.07.2026 ca. 13:50Z–22:00Z+ (Manager-Session = "main"/Fable, Impl via Opus-Subagenten). Keine Secret-Werte im Chunk zitiert oder zitierbar.

---

## (a) USER-DIREKTIVEN (chronologisch, wörtlich wo bindend)

**U1 — Kontextübergabe (Chunk-Anfang)**
> "Bitte schreibe eine elaborate Kontextübergabe, der kontext endet jetzt, wir arbeiten im nächsten Kontext direkt weiter"

danach `/compact` mit Argument:
> "Bitte merke dir alle TODOs, Planung, Architektur, die letzten 7 neuesten Dokumente und den Verlauf der letzten Session für den nächsten Kontext"

**U2 — §39 Autonomie + Infra-Freigabe (revidiert "Cluster read-only")**
> "sobald alle Voraussetzungen erfüllt sind, autonom fortfahren - auch nachts bitte. Volles GO für alle Punkte. Das Cluster ist nur für dich reserviert und du hast die Freigabe Infrastruktur autonom einzurichten mit den Schlüsseln aus dem cred vault. Der einzige Blocker sei die Implementierung, um die du dich kümmerst"

**U3 — §40 (a/b/c): SIMD-Flag-Signatur, dynamische Planer-CI, Bare-Metal**
> "Das avx512 flag ist jetzt zwar doppelt in den gitlab runnern aber es funktioniert. Bitte bedenke, dass AVX512 eine Signatur aus Flags besitzt, und nicht jede CPU hat alle AVX512 flags bzw. Befehlssatz Erweiterungen. Hier muss also jedes einzelne AVX512 flag einzeln als von der Maschine als vorhandene Hardware deklariert werden. Dagegen sind auch nicht alle AVX512 flags auf der CPU für alle Organ-Achsen sinnvoll einzusetzen. Bitte recherchiere im web, wie die Flags heißen. Bei AVX256 verhält es sich ähnlich, aber es gibt nicht so viele flags und eine einheitlichere Unterstützung. Es gibt auch AVX128 (alt), das damals auch als das erste SIMD bekannt wurde. Bezüglich der Lösung der Builds sehe ich derzeit nicht, dass der Experiment-Planer direkt aus der XML die Eigenschaften der CEB erkennt und diese aus Metaprogrammierung dynamisch auf der CI kompiliert (Planer läuft nach build und setzt dann als automatische Aktion den Rest der CI für die nachfolgenden Abhängigkeiten), sodass diese dann für die Maschine passende CEB dynamisch die CI mit den Tier-Binaries als echte dynamische CI jobs baut. Ich sehe eine statische Liste an Rekombinationen in der CI aber die Steuerung liegt nicht im Planer oder darauffolgend in der CEB. Das muss sich bitte ändern. An sich dient die aktuelle Einstellung als erfolgreicher Pilot. Weiterhin ist die Voraussetzung nicht erfüllt, dass wir auch bare metal compile ohne gitlab CI nach Plan/Ledger erfüllen. Soweit alle Pipelines grün und erfolgreich"

**U4 — §41 / GN-11-Entscheid (Deadline-Scope)**
> "Wir bauen alles new golden und messen alles mit der 320er. Wir messen new golden ab dem 01.08. . Bis Freitag müssen wir nur nachweisen, dass wir alles bauen und das Meiste CI und lokal messen können"

**U5 — Infra-Störung**
> "Seit einigen Minuten werden keine jobs aufgenommen"

**U6 — §42: Steuerungs-Architektur ist falsch (Kern-Direktive dieses Chunks)**
> "Warum baut build-golden-n Versonen wie [avx2,avx2, default, O2, 1] . Mir ist die Achse Default nicht bekannt, ich weiß auch nicht, warum die builds für den measure nicht per XML Konfiguration dann der cache engine zugeordnet werden, die ja per Definition die XML Anfrage des Anwenders (Diplomarbeit) erhält. Es muss also eine build-Stufe für Mess-Achsen mit Achsen Array für je eine dynamische CEB pipeline, dahinter die build-Stufen je paralleler CEB-Messsystem Build mit jeweils den System-Achsen und zuletzt die Tier-Binaries mit je einer kurzen Legende-Array jeweils in einer CEB zugeordneten pipeline zu finden sein. Mess-Achse[a,b,c]->[a,b,c]CEB-Typ->CEB definiert System-Achsen [d,e,f]->[d,e,f]Pipeline-für-Build-Freigegebenen CEB-Raum->CEB-Raum permutiert System-Achsen[d,e,f] und Organ-Achsen[g,h,i]->[d,e,f,g,h,i]Tier-Binary XOR ([d,e,f,g,h,i]Hybrid-Heuristik-Tier-Binary->ausgemessene beste no permutation und static pick [d,e,f,g,h,i]Tier-Binaries). Nur die Delegation an den XML-Planer gehört in die Diplomarbeit und das holen der Messergebnisse gehört auf der Grundlage der cache engine lib in die Diplomarbeit CI auf Delegation der cache engine Framework lib. Eigentlich erhält die Cache Engine die XML und übernimmt die gesamte Arbeit (delegiert von Diplomarbeit). Die CI ist falsch und das Konzept der lokalen compile damit auch."

**U7 — §42.b: Haupt-/Unter-Achsen-Trennung (Bau vs. Messung)**
> "Bitte beachte, dass ich in meiner Beschreibung nur die [d,e,f,g,h,i] Hauptachsen benannt habe, zu denen es dynamische Unter-Achsen-Parameter d[d1,d2,d3] gibt, die zur Laufzeit nur bei der Messung durch-permutiert werden aufgrund einer gewählten Haupt-Achse und darunter verfügbarer Laufzeit-Parameter. Die Laufzeit parameter werden immer von ihrer Haupt-Achse freigegeben (Haupt-Achsen gegeben den CEB Untersuchungsraum der Haupt-Achsen an sich UND den Unter-Achsen-Raum je Haupt-Achse frei). Die Unter-Achsen rekombinationen [d[d1,d2,d3],e,f,g,h,i]Tier-Binary werden als volles Array nur zur Messung zur runtime der CEB und zur Laufzeit einer Haupt-Achsen gekoppelten Tier-Binary (mehrer Unter-Achsen Permutationen je Haupt-Achsen-Permutationen zur Laufzeit des Tier-Binaries, Wiederverwendung desselben compiles) , permutiert und durchgemessen. Eine Array-Permutation der HAUPT-Achsen für ein Tier-Binary ergibt einen dynamisch angelegten Mess-job, der alle Unter-Achsen-Permutations-Messungen unter der Haupt-Achsen-Permutations-Einstellung beherbergt und als csv zurückschreibt. Bitte bedenke, dass die Mess-Achsen dynamische laufzeit Unter-Achsen bezüglich Mess-Framework workload besitzen, die zur Laufzeit des Experiment-Planers gegen alle CEB permutiert zur Messung beautragen."

**U8 — 3 Infra-Fragen**
> "Wie weit ist der CI build und mit welcher Geschwindigkeit schreitet er voran? Werden die builds koorekt cluster prod minio abgelegt bezüglich der generierten builds? Werden fertige builds async auf das prod minio gestreamed, um keine Performance für das Zurückschreiben einzubüßen?"

**U9 — §43: Selbst-Versionierung der Binary-Kette (Stempel)**
> "Bitte erweitere den Standard der Deklaration einer [d,e,f][g,h,i]Tier-Binary erweitert wird derart, dass jede Achse den durch sie gewählten Algorithmus Algorithmus und daher das gesamte Array an Achsen-Algorithmen und Einstellungen der Haupt-Achsen als string_view in die Tier-binary zur Versionierung einkompilieren. Dieses statische Versionierungs-Array einer Tier-Binary gibt uns die Möglichkeit zu erkennen, welche Tier-Binaries bei Update eines einzelnen Achsen-Algorithmus neu gebaut werden müssen und welche nicht. Unveränderte bleiben bestehen und können aus dem cache wiederverwendet werden. updated-Tier-binaries werden im cache neu kompiliert und ersetzt. Dasselbe Prinzip gilt für die erstellung von [a,b,c]CEB durch den Experiment-Planer bezüglich der statischen compile Time Haupt-Achsen der CEB, auch diese hat einen string_view für ihre [a,b,c] Mess-Achsen-Version. Die Tier-Binaries haben ihren string_view Versionierungs-Stempel über die [d,e,f][g,h,i] Kombination in 2 verschiedenen String_view Zeilen, eine für System-Achsen und eine für Organ-Achsen Algorithmus-Versionen. Natürlich braucht jede Achsen Version (Mess/System/Organ) jeweils auch die Zuordnung der Achsen-Beschreibung und des gewählten Algorithmus der Haupt-Achse jeder Kategorie, um die Version zuordnen zu können."

**U10 — §43.b: Reload-Test, Async-Push, Planer-Stempel, X.Y.Z-Schema**
> "Zu meiner zweiten Frage: hast du das relaod und die Wiederaufnahme der Kompilation aus dem cluster prod caching getestet und kannst du bitte async zurückschreiben einrichten, damit der compile noch schneller geht? Bei zehntausenden DLL beziehungsweise eher .so auf linux, brauchen wir maximale Optimierung der Infrastruktur, sonst geht der Build Wochen statt Tage. Ach ich vergaß beim Stempel, dass der Experiment Planer auch einen string_view Stempel trägt, aber nur über die eigene statische Versionierung und unter welcher ISA/OS er passt und ausgeführt werden kann. Die Versionierung und Stempel sind X.Y.Z mit X.Y die Feature Version und Z die Revision des debuggings im selben Feature Stand, das gilt für jeden Achsen-Algorithmus (alle Typen) einzeln, sowie für den Experiment-Planer statisch."

**U11 — §44: W12 vorziehen + manuelle Session-Konsolidierung**
> "Bitte ziehe die Implementierung des Versionierungssystems als Teil der infra Optimierung nach vorn, damit wir zusammen mit optimalem caching mit maximaler Geschwindigkeit bauen können und nur das neu bauen, was wirklich benötigt wird. Bitte gehe die gesamte Session einmal gründlich durch und suche manuell nach vergessenen TODOs und zusammenhängne und konsolidiere manuell. Dann weiter wie gehabt. Prüfe, was im Ledger noch nicht niedergeschrieben wurde und persistiere es"

**U12 — §45: Voll-Bau STOPP, Optimierung zuerst, Rot-Periode erlaubt**
> "Ich denke es ergibt wenig Sinn die unoptimierten builds weiter durchlaufen zu lassen, wir sollten uns gleich zuerst um die Restrukturierung der CI und die Optimierung kümmern, damit wir die optimale Grundlage haben, effizient neue Features zu implementieren, das wird sonst nie fertig. Dafür akzeptiere ich auch eine Zwischenperiode rot. Dabei müssen wir aber die workflows abwarten, um nicht mit ihnen zu interferieren. Ich würde den voll-build nur unter optimierter Pipeline fahren, betrachte das als gate. Ich bestätige also deine Strategie."

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begründung)

**§39 (Manager):** Infra-Autonomie entsperrt zwei bisher delegierte Blocker (Runner-Tags, measure-drop-401) → Manager setzt Runner-Tags selbst (prod1 `+amd64,avx2,avx512`; prod2 `+amd64,avx2`, API-verifiziert).

**§40.a — SIMD als Flag-Signatur (Design von simd-flag-recherche, entschieden von Fable):**
- Maschinen-Signatur liegt in bestehender Host-Capability-Domäne `hardware_isa_system_axis.hpp`/`machine_simd_signature.hpp` (Entscheid 1) — keine Parallel-Struktur; grober `SimdSubAxis {no_extension,avx2,avx512}` **bleibt** als reine Runner-/Routing-Vorstufe (nicht löschen, zu Routing-Tag degradieren).
- Flag-Katalog `measurement/simd_feature_flag.hpp` = code=Wahrheit, 23 Einzel-Flags; cpuinfo-Id UND g++/clang-Flag **hart getrennt** (Unterstrich-Falle CT-zementiert: `avx512vbmi` ohne / `avx512_vbmi2` mit) — nie per String-Heuristik ableiten.
- Organ-Sinnhaftigkeit zentral in `measurement/simd_organ_sensibility.hpp` statt in `topics/09b` — **Entscheidung-3-Abweichung akzeptiert**: `topics/` inkludiert nie `<cache_engine/measurement/...>`; physische Ablage in 09b wäre neue Rückwärts-Abhängigkeit (Layering-Bruch). Referenzierung per Name-String.
- Gate (E4) **in derselben Welle**, sequenziert nach W6, weil es exakt auf der `provision_all`/`make_gpp_compile_fn`-Naht liegt: "Ohne Gate wäre §40.a nur Phantom-Deklaration."
- Gate = GoF **State** (Prüf-Dock: `Ungeprueft→{NotApplicable|Freigegeben|Abgelehnt}`), zero-cost/constexpr, keine vtable; Fehlerklassen **an bestehende `axis_error.hpp` angedockt** (`HardwareErweiterungFehlt` / `CompileKombination` / `ToolchainFehlt`), keine neue Taxonomie; `effective_flags = Signatur ∩ organ_meaningful ∩ route_allowed`, emittiert **einzelne** `-m`-Flags statt pauschalem `-mavx512f`; `binary_id` unberührt → golden-neutral.
- Heute bewusst **inert**: kein Organ deklariert `required` → `static_assert(!any_organ_declares_required())`.

**§40.b/c (W7):** CiYamlBuilder als 4. ConcreteBuilder am selben Director-Walk (Topologie-Isomorphie); GitLab-Nesting parent→child→grandchild via `trigger:include:artifact`; statische 24-Zellen-Matrix bleibt **Pilot-Fallback**. CMakeGraphBuilder scharf + `MANUAL_RUN.md` = Bare-Metal-Pfad ohne CI.

**§41 / GN-11:** Bau = alles new-golden (2¹⁷ je System-Permutation); Messung = golden-320; new-golden-Messung ab 01.08. als Anschlussarbeit. Begründung (Fable, vom User bestätigt/korrigiert): Voll-N-Messlauf ≥15 Tage bei 1-Thread-Doktrin → deadline-untauglich.

**§42 (W10):** super-CI schrumpft auf `planer:delegate` + `ergebnis:holen`; CE erhält die XML und übernimmt alles. Child-1 = je Mess-Achsen-Kombination `[a,b,c]` eine CEB-Pipeline; Child-2 = **die gebaute CEB emittiert selbst** System-Achsen-Stufe `[d,e,f]` + Tier-Jobs `[d,e,f,g,h,i]` (§40.b-Hoheit). Lokaler Compile-Pfad **identisch dreistufig**. §41-Abnahme erfolgt gegen die W10-Kette, **nicht** gegen den Piloten.

**§42.b:** Bau = **Haupt-Achsen-only** (Compile-Wiederverwendung), abgesichert durch eigenes Contract-Gate; zweischichtige Freigabe (Haupt-Achse gibt Unter-Achsen-Raum frei, CEB gibt beides frei); Mess-Job-Granularität = genau eine Haupt-Achsen-Permutation, die den vollen Unter-Achsen-Sweep zur Laufzeit fährt und **ein** CSV zurückschreibt.

**§43/§43.b (W12):** Stempel **in** die Binary (selbst-identifizierend), **pro Achse zuordenbar** (Achse→Algorithmus→Version). Tier = 2 `string_view`-Zeilen (System `[d,e,f]` / Organ `[g,h,i]`), CEB = 1 Mess-Achsen-Zeile, Planer = Selbst-Version + ISA/OS. Sidecar bleibt als Datei-Spiegel (mc-Objektstore kann Binaries nicht billig öffnen). X.Y.Z gilt je Achsen-Algorithmus einzeln; auch Z-Bumps invalidieren den Cache.
- **Byte-Schutz-Vorgabe (kritisch):** `compose_algo_signature` + `algo_version` bleiben unangetastet; X.Y.Z ist reine **Parse** (`"v1"`→1.0.0); kein gemeinsamer Formatter — sonst würde die Migration den frisch gebauten Cache invalidieren.
- 5 Architektur-Entscheide gegeben: (1) `kSystemAxisVersionLine` = statische System-Achsen-**Algorithmus**-Versionen (Emitter bleibt system-blind, W4-B-Invariante hält); Zellwerte kommen zweiphasig in W10 an der CEB-Naht. (2) nur `"vN"`/`"vN.N.N"`, keine Kurzform. (3) strikt getrennte Registry-Felder. (4) neues ABI-Symbol optional/additiv → **kein Major-Bump**. (5) kanonische Ordnung = compose-Reihenfolge.
- **Fork-Entscheid am Blocker:** (A) Emitter injiziert Stempel **über einen geteilten Ableitungs-Helfer**, den beide Emitter-Pfade rufen → Roundtrip-Wache bleibt **strikt** (kein modulo). Fork (B) (Wrapper-Liste durchs ABI-Makro) **abgelehnt** — hätte 209 Wrapper an die Makro-Signatur gekoppelt.

**§45:** Voll-Build-Gate = optimierte Pipeline. Befristete Rot-Periode als bewusste Ausnahme dokumentiert (Ende = W10-Abnahme, danach gilt hart-grün wieder uneingeschränkt). Reihenfolge: Workflows abwarten → Sammel-Kadenz W9+W11+W12-A → W10+W12-B → Voll-Build.

**W11-Design:** Async-Push = **dedizierter Push-Thread + Queue** (nicht push-in-worker: hätte Compile+I/O gekoppelt, mc-Sturm und nichtdeterministische Marker-Kadenz erzeugt); Mess-Modus bleibt **strikt synchron** (Doktrin async=Messfehler); `close()`=Drain+join **vor** dem Whole-Chunk-Marker (Vollständigkeitsgarantie).

**Prozess-Entscheid:** Task-Zuweisung ≠ Start-Signal — beim #31-Verstoß (w6-parallel baute vor dem Gate-Nod) klar adressiert; Agent hat Regel dauerhaft ins Memory geschrieben. "Diesmal folgenlos, bei golden-Nähten nicht tolerierbar."

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS

| Paket | Inhalt | Verifikation (literal) | Commits |
|---|---|---|---|
| W4-Nachsteuerung | §36/§37/§37.b Freigabe-Kopplung dokumentiert-bewiesen (existiert bereits an `system_axis_march_of`→`perm_compile`/`provision_all`); Gate-Test (d) System-Blindheit | Passed, CRC64-Anker | ce `038c90d7` / super `66a7fad` |
| Kontextübergabe | `docs/sessions/2026-07-19-SESSION-UEBERGABE-wellen1-4-pool-maschinerie-komplett.md` | Mojibake 0 | super `28efb82` |
| Infra-Handout | P7 (401), P8 (Runner-Kill), P9 (Tag-Erinnerung) | — | Cluster `425e712` |
| W5-B | `--dump-plan`-CLI + CMakeGraphBuilder + 4 Contract-Tests | 281/281; byte-identisch über 2 Läufe | ce `bff6a4d1` |
| W5-C/C+ (+N1/N2) | §38-Dock-Payload (R5-XML, Byte-Roundtrip), ProgressDelta-Rück-Kanal, GN-Zellen-Filter in **beiden** Walks; N1 Layering-Verlagerung nach `builder/experiment_tree/progress_delta.hpp`; N2 Experiment-Spiegel-Filter | 283/283; DOCK_PAYLOAD_OK / PROGRESS_DELTA_OK / GN_CELL_FILTER_OK | ce `d7d35c36`, super `2407903` |
| Ebene-C-Fix + Lock-Gate | measure-drop Basic-Auth; `contract:axis-version-lock` als hartes CI-Gate | Bearer→401, Basic→201 live | ce `95a6556d`, `d07f8f31` |
| Kalibrierung | Pipeline 11453 **24/24 success, 0 Fehler**; Tag-Routing, Locking, Dedup, 1042 MinIO-Objekte (521 DLL + 521 Sidecar), ~580–690s/Zelle, ~428 KB/DLL → ~56 GB für 2¹⁷ | terminal success | — |
| SIMD-Referenzdoc | `docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md` (219 Z., quellenbelegt, **live auf prod1 gegengeprüft: 100 % Treffer der Zen5-Vorhersage, 13 avx512-Flags inkl. `avx512_vp2intersect`, kein `fp16`**) | — | super `f422fa6` |
| W6+W7+W8/E1–E3 | Bau-Pool-Parametrisierung (`COMDARE_BUILD_PARALLEL`, **2.52× real**), CiYamlBuilder + scharfer CMakeGraphBuilder + `MANUAL_RUN.md` (**Bare-Metal: 69 Binaries in 94s ohne CI**), Flag-Katalog/Signaturen/Sinnhaftigkeit + Registry 93→166 Z. | 285/285; Registry-Roundtrip byte-identisch; `ninja: no work to do` = golden-neutral; beide YAMLs GitLab-lint valid | ce `ada83799`, super `cf3b774` |
| W8/E4 (R1 + Live-Naht) | `simd_build_gate.hpp` (State-Pattern), `simd_organ_requirement.hpp`, Naht in `compile_for_perm` + `provision_core` | 285/285; 3 Inertness-Beweise; CI 11499/11500 success | ce `13e09953`/super `24e33ea`, dann ce `b85b0eed`/super `f53648c` |
| Ledger | §39, §40+§40.b (`48cecbf`), Wellenplan W7–W9 (`f355740`), §41 (`0258196`), §42 (`76aeb64`) + W10-Bauplan (`7d4b94e`), §42.b (`68a0c80`), §43 (`2b86b31`), §43.b (`c1cece8`), §44 (`d7b4e11`), §45 (`1228a80`), Gate-Swap (`8e2cc7e`) | — | super |
| W9 (7 Punkte) | H-10-Sidecar-Aufrufer (telemetry-Provenienz-Token, registry-gegated = Anti-Drift), G8-Doku-Drift (~90 Kommentare/35 Dateien), build-i2 (stale-dir, 3/3), `COMDARE_GOLDEN_320_BYTE_GUARD_IDS`-Rename + DEPRECATED-Alias, G4/G5/G6/G9/G10, Mess-Pre-Flight-Anchor, **K5-Abgleich: 83 Befunde, 0 messlauf-blockierend** | 285/285, build-i2 3/3 | in Sammel-Kadenz |
| W11 (§43.c) | `async_push_pump.hpp`, `set_on_binary_done`, Teil-Marker je 1024, Single-Source `cache_key_prefix` (heute Identität) | 12/12; Overlap-Mikro 2506→1523 ms (98 % versteckt); **Resume-Beweis: SIGKILL@25s → Neustart baut 73 neu, 6 resumiert** | ce `94d10252` |
| #31 Root-Cause | `n_sweep.resize(1)` im provision_only (N-Sweep = Mess-Parameter, kein Compile-Freiheitsgrad) | provisioned **276→69**, mc-cp **552→138**, DLL-Menge identisch | in Kadenz mitgereist |
| Sammel-Kadenz W9+W11+W12-A | cf22 über 73 ce-Dateien + super | **287/287**, Mojibake 0, Lock safe; CI 11541/11538 + 11543/11544 grün | ce `94d10252`,`3e348bb8`,`6771e736`,`10805cfe`; super `2459385`, `c4947ee2`/`3fa51c9` |
| W12-A2 (Injektion) | POD `AnatomyVersionLines` + optionales `comdare_anatomy_version_lines()` (kein Major-Bump), Makro `COMDARE_ANATOMY_VERSION_STAMP`, beide Emitter-Pfade via `compose_organ_stamp_line` + Präsenz-Guard | Roundtrip 320 **strikt** (8/8), CRC64 `0xF1C1F26A1232073B` == Anker, 287/287, **In-Binary: `strings` + `objdump -T` belegen Symbol**; CI 11548/11549 grün | ce `3549f9fb`, super `c29f1e5` |
| W10 (A/B/C) | `plan_legend.hpp` (Single-Source), dreistufiger Director-Walk, `TierCiYamlBuilder`/`TierCmakeGraphBuilder`, `--emit-tier-ci`/`--emit-tier-cmake`, `planer:delegate`+`ergebnis:holen`, statische Matrix DEPRECATED-gated | 23/23 Contract, 287/287; byte-determin. (3313B/21999B/2794B/25553B); **dreistufiger Bare-Metal-Beweis: 69 DLLs, rc 0, ~82s** | ce `e6f014a9`, super `d0f3d66` |
| W10-Nacharbeit | `emit_child_ccache_config()` in beiden `begin_plan` (Parent-Spiegel) | 24/24 (`BothStagesEmitParentMirroredCcacheConfig`), 287/287, alle 3 YAML-Ebenen lint valid | ce `cc37f4e5`, super `b8974ba` |
| Handover W12-A2 | `super/docs/plaene/…HANDOVER.md` (5 Edits + 6-Punkt-Verifikation + Fallstricke) | — | super `3fa51c9` |

---

## (d) FEHLER + FIXES

1. **measure-drop HTTP 401 (Ebene C).** Kein Infra-Problem: Dienst verlangt **HTTP Basic** (`measure:<token>`), CE-Client sendete `Bearer`. Live bewiesen Bearer→401 / Basic→201. Fix in `artifact_cache.hpp` + `COMDARE_NFS_DROP_USER` (Default `measure`).
2. **4×-Redundanz je CI-Zelle.** `COMDARE_GN_OPT`/`GN_SIMD` wurden von **keinem Code konsumiert** ([PERM] 4× in beiden Traces, byte-identische GN-9-Werte auf O2/O3) → §36.1 (eine Permutation = ein Runner) griff nicht. Fix: `gn_cell_filter.hpp` (W5-C+) in beiden Walks + Zähl-Test.
3. **Layering-Bruch (W5-C).** Iterator (`builder`) inkludierte aufwärts nach `profile_facade/planner` → N1: `progress_delta.hpp` in die builder-Schicht verlagert; Grep-Beleg: kein `#include profile_facade` mehr im `builder/`-Baum.
4. **`mc` fehlte auf prod2** (Ebene-B-Push/Dedup lief dort nicht) → per SSH installiert. **Nebenbefund/Korrektur:** "10.0.10.12 = prod2" ist **falsch** (das ist die OPNsense opn-2); prod2 = `10.0.10.212`.
5. **Selbst verursachtes Vault-Leck:** `tail` auf den DEV-Vault hob Werte ins Transkript → betroffene Rollen (nur md5-Tags) an die #327-Rotationsliste; neue Regel persistiert: **Vault nie `tail`/`cat`, nur feld-gezielte Extraktion.**
6. **Job-Aufnahme-Stau (U5).** Ursache: zwei **verwaiste `comdare-messung-driver`-Prozesse** auf prod1 (12,5 h / 4,6 h alt, Überbleibsel der gecancelten Smokes 11365/11401 — Runner-Handler gekillt, Driver lief kopflos weiter, Last ~4–5) + zwei gleichzeitige Integrations-Pushes. Fix: SIGTERM (Mess-CSVs unangetastet). Lehre P11 → **W9.6 Pre-Flight-Anchor** `.measurement_preflight_no_foreign_driver` (pgrep, harter `exit 1`) in `measure:smoke` und `measure:golden-320`.
7. **Akuter Fund der Session-Konsolidierung: `timeout: 2h`** im `.golden_n_build`-Template (Pilot-Wert) vs. ~8 h Zellenbedarf → die 5 laufenden Voll-Zellen wären ab 20:08Z am Job-Timeout gestorben. Fix: 30 h (`4189b87`, lint valid), 11509 gecancelt, als **11519** neu gestartet (Preis ~75 min × 5 Zellen).
8. **Pull-Pfad-BUG (W11-Fund): die Cluster-Resume-Naht war faktisch tot.** Pull ging nach `gn_out/<PREFIX>/`, der Treiber-`dll_dir` ist `gn_out/<PREFIX>/e4_xml/dll/` → nie hydriert. Beide Pull-Zweige korrigiert. Zusätzlich `COMDARE_GN_COMPILER_TAG` war **leer** → per-DLL-Pull deaktiviert → auf `g++-16` gesetzt.
9. **W12-A Blocker (Live-Code-Befund):** `organ_stamp_line<Comp>()` nicht ableitbar — die realen AdHocComposition-Slot-Typen sind **Strategie-Typen ohne `name()`/`algo_version`** (`'name' is not a member of AdHocComposition<...>::search_algo`); nur Registry-Wrapper tragen sie. Lösung: **`compose_organ_stamp_line(axes, table)`** neben `compose_algo_signature`, Ableitung aus der Version-**Tabelle**. Agent hatte ABI-Makro-Additionen sauber revertiert und den Baum grün gelassen.
10. **Child-YAML erbt Parent-Globals nicht** (E2E-Lauf 11562): ccache fiel auf `$HOME/.ccache` → `/.ccache/lock: Permission denied`. Fix: `emit_child_ccache_config` (CCACHE_DIR/MAXSIZE/CMAKE_BUILD_PARALLEL_LEVEL + top-level `cache:` mit Parent-Key) in **beiden** Stufen.
11. **Kleinere:** Push abgelehnt (Infra-Agent parallel gepusht) → fetch+merge (nie rebase). Scheinfehler: 2 "error"-grep-Treffer waren der Testname `test_axis_error_taxonomy`. build-i2-"Rot" war ein **stale Build-Verzeichnis**, kein Include-Bug. Lokale r5g-Codegen-Staleness (stale 18-vs-17) — Hygiene-TODO, kein CI-Blocker. Task #31 war fälschlich abgehakt → zurück auf pending. HANDOVER-Doku zunächst ins falsche Repo (ce) geschrieben → nach super verschoben.
12. **Wiederkehrendes Agenten-Muster:** Idle-Notification ohne Report (Zustellungs-/Antwort-Rennen bei w5c-dock, w7-dynci, w9-konform, simd-flag-recherche) → Manager musste jeweils explizit Report/Weiterarbeit anfordern; einmal mit explizitem "erst mit dem Abschlussreport antworten"-Befehl durchbrochen.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

**Unmittelbar laufend**
- **Serie-E2E-Lauf #2, Pipeline 11569** auf ce `cc37f4e5` / super `b8974ba` (Fix-Stand) — Monitor auf Pipeline/Bridge/Child. Lauf #1 (11562) hatte 3 von 4 Ketten-Beweisen erbracht: `planer:delegate` success, Child-Pipeline **11566 real instanziiert**, **Child-Submodul-Auth funktioniert** (letzter offener W7-Punkt); nur die Bau-Umgebung (ccache) scheiterte.
- **§45-Gate noch NICHT erfüllt** → erst bei Grün startet der Voll-Build mit voller Range über die neue CE-gesteuerte Kette.

**Direkt anschließend geplant**
- Voll-Build new-golden über die W10-Kette (`COMDARE_BUILD_PARALLEL=8`, async Streaming, Cluster-Resume, Stempel-Invalidierung). **Gate-Swap beachten:** `COMDARE_BUILD_GOLDEN_N=true` triggert jetzt die dynamische Kette; die statische Pilot-Matrix braucht zusätzlich `COMDARE_STATIC_MATRIX_FALLBACK=true` (DEPRECATED).
- **W12-B**: Stempel in `ArtifactCache::cache_key_prefix` einhängen — **muss spiegelbildlich mit `GN_PREFIX` in `.gitlab-ci.yml` (Z.738) nachgezogen werden**, sonst Pull-Key ≠ Push-Key. Einzige C++↔YAML-Sync-Stelle.
- **Task #32 / W12-A3**: SOTA/PRT-ART-Emitter (`render_sota_module_source`, `sota_catalog.hpp:105`) ist ein **dritter Emitter ohne Stempel** — gemessene Tier-Binaries ohne Versions-Identität; Form-Entscheid nötig (benannte externe Compositions haben evtl. kein per-Achsen-`algo_version`). Diagnose-Pfad (`emit_adhoc_modules`, `apps/adhoc_emitter`) bewusst ungestempelt.
- **Task #30** (GO-pflichtig): `axis_observer_classification.hpp` führt telemetry+isa weiterhin als `SearchAlgorithmObserver` (count 19/26 statt 17) — echte Substanz-Drift, golden-relevant, bewusst nicht vor dem Messlauf.
- **§40.a-Gate-Aktivierung**: fehlen (a) echte `organ_required`-Deklarationen und (b) per-Binary-Granularität; heute CT-zementiert leer.

**Infra / Beweise offen**
- **Marker-SKIP-Livebeweis** (Zelle komplett fertig → Folgelauf überspringt) nie live getroffen.
- **PAT-Rotation Sammel-#327** (inkl. der neu vermerkten Rollen) und **P8 Runner-Kill-Frage** bei Infra offen.
- W11-**Teil-Marker-Zähler ist per-Pass** — robustere Variante (Zähler über alle Passe) als Mini-Increment offen.
- Mehrere Mess-Kombinationen: Walk strukturell vorbereitet, heute `size=1` (`[all]`-Sentinel).
- Lokale r5g-Codegen-Staleness (Hygiene), K5-Restliste 14 relevante-nicht-blockierende Befunde (Vor-Abgabe-Härtung), gebündelte offene User-GO-Forks O-1/E-2/O-13.

**Termin-Fahrplan (§41, verankert)**
- **Fr 24.07.**: Voll-Matrix-**BAU**-Nachweis new-golden + Messfähigkeits-Nachweis in CI **und** lokal (MANUAL_RUN/Bare-Metal).
- **bis 28.07.**: golden-320-Voll-Messlauf als Abgabe-Messdatensatz (zwingend nach W9.1 H-10 ✓), dann M-4-Auswertung und #47 Thesis-Kapitel + Anhänge.
- **ab 01.08.**: new-golden-Voll-Messung als Anschlussarbeit.
- Rot-Periode per §45 zulässig **bis zur W10-Abnahme**; danach gilt "gesamte Pipeline hart grün" wieder uneingeschränkt.