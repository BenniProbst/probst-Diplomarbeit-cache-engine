# SESSION-ZWISCHENSTAND-02 (2026-07-20) — KERN-Redefinition, Band-B-Reparatur, golden-Verifikation

> Reicher Sicherungs-Snapshot des autonomen v3.2-Laufs am 20.07. (Autonomie-Grant). Zweck:
> Kontext-Übergabe-fähige Konservierung des erreichten Stands nach der KERN-Mess-Schema-Redefinition
> durch den User + der Konsolidierung von vier ultracode-Planern. Fortschritt gehört per Doku-Policy in
> NEUE Session-Docs; Ledger/Arch/Pläne werden nur im Rahmen der EINMALIGEN User-Ausnahme-Freigabe (#22)
> angefasst.

---

## 1. Wo wir stehen (Kurzfassung)
Der autonome Lauf hat vier golden-neutrale Pakete gelandet (alle CI-grün), der User hat die **Mess-Schema-Steuerung als KERN neu/autoritativ beschrieben**, vier Planer haben konsolidiert (KERN-Bau, Band-B-Reparatur, golden-Verifikation, S3-Aktivierung), und mehrere GOs wurden erteilt. Der golden-CRC ist bewiesen **unverändert**. Jetzt laufen der finale KERN-Bau-Plan + die Runner-Tag-Infra-Vorbereitung; danach: Persistierung (#22) + KERN-Bau.

## 2. Gelandete Arbeit (autonom, jeweils ultracode-Plan → Opus-Impl → Manager-Verifikation → Dual-Push → CI-grün)
| Paket | Inhalt | ce | super | CI |
|---|---|---|---|---|
| CI-Fix | `test_e4` fehlendes `Boost::mp11` (transitiv via A4-profile_to_tree) | 66e73730 | 2954765 | grün 11731/11732 |
| **S2/A2** P-SYSREG | System-Achsen-Consumer `atomic128`+`target_isa` verdrahtet (B1-voll) | 2ce1aaa2 | 13d3efd | grün 11736/11737 |
| **S3** P-RESOLVER | minimal-3-tief: `resolve_axis_refs_against_trio` (V-UNREG-AXIS/V-CATEGORY), INERT-by-default | f6dca47b | 2404c6a | grün 11741/11742 |
| **S2/A4** P-HYBRID | monotoner Fritsch-Carlson-Spline gegen Break-Even-Overshoot | ca3e3a7e | ae9d42b | ce grün 11746 (super-CI läuft) |

Verifikations-Kadenz je Paket: cf22 (clang-format 22.1.8) 0-diff · Mojibake 0 · ctest literal · Include-Kette boost-frei · super-Sub-Build · RegistryTrio 17/5/16 · golden-neutral · Dual-Push (origin=gitlab.comdare.local + github).

## 3. DIE KERN-REDEFINITION (User 20.07., AUTORITATIV — „schon immer Gesetz")
Der User hat die **Mess-Schema-Steuerung des Planers** als KERN festgelegt (NICHT vertagbar). Gesichert als Memory `project_planer_mess_schema_kern_pruefling_replace_merge_fulljoin` + Autoritäts-Regel `feedback_user_kern_beschreibung_ist_immer_gesetz_abweichung_ist_regression`.
- **Default = ALLES messen.** XML = **negatives Blacklisting** (aus der Whitelist aller Achsen/Einstellungen/geladenen Prüflinge werden nur Teilbereiche freigegeben).
- **3 Stufen:** ① CE allein (permutativ über alle Achsen) → ② jeder **Prüfling** direkt danach, Default **replace** (Prüflings-Achsen ersetzen CE-Achsen komplett), alternativ **merge** (CE+Prüfling-Hybrid je Prüfling) → ③ **kombiniert = full join** je Achse (verwirft nichts).
- **XML steuert:** Messmodi · alle vs. bestimmte Achsen merge/replace · welcher Prüfling (Variablenname ODER statisch `"CacheEngine"`) · per-Achse Algorithmus-Whitelist · ODER Template (Research-Gesamtalgorithmus) laden + je Achse restrict/extend.
- **Planer→CEB:** Planer parst XML → CEB versteht je Achse; **Haupt-Achsen statisch per Metaprogrammierung in die CEB einkompiliert** → Interpreter je Haupt-Achse fix → CEB-Laufzeit (Planer-orchestriert) treibt Tier-Emit.

### 3.1 Klärung id-Satz + Storage + Stempel (User, gleiche Runde)
- Prüfling-Merges = **EIGENER ID-SATZ** (Tier-Binaries MIT allen Mess-Artefakten zusammen), dem Prüfling zugeführt + gespeichert.
- **Storage:** Unterordner unter root **LOKAL (Default)** ODER per XML in **`minio.comdare.de`** (Cache).
- Nur Prüflingsseite gemessen → eigener id-Satz; bei Merge/Join → **je Merge-/Join-Art eine eigene Mess-Kategorie der Artefakte, mit-gecached**.
- **STEMPEL:** Namen + Versionen JEDER Achsen-Algorithmen IMMER im Stempel; PLUS ein **DRITTER Tier-Binary-Stempel = die Merge-Kombination** (zusätzlich zu §58 System-Array + Organ-Array).
- **golden-Konsequenz:** ce-only-golden `0xF1C1F26A1232073B` bleibt **byte-identisch** (Merges = additiver id-Satz; ce-only-/Identitäts-Pfad byte-gleich).

## 4. CoreSchema-Befund + 6 Forks (Manager aus Spec entschieden, User-GO)
**Kern-Befund:** Die 3-Stufen-Merge-Maschinerie existiert bereits compile-time + per-Achse (`pruefling_merge.hpp:137-158` `MergeAxis`), ist aber **katalog-verdrahtet auf EINEN hart-codierten Prüfling (`prt_art`) + EINEN Slot (`path_compression`)** via `sota_catalog.hpp`. KERN = Generalisierung (beliebige Prüflinge, per-Achse, XML-gesteuert). **Kein Neubau — Umverdrahtung + Schema.**
**Dekomposition K1–K6:** K1 (Schema-Structs+Parser+XSD) · K2 (validate) · K3 (`<phases>` 1..unbounded, E11-A) · K4 (deklarative `merge_plan_from_profile`-Naht) · K6 (Auto-Phasen-Ableitung) = **golden-neutral**; **K5** (`sota_module_for` katalog-fix → direktiven-getrieben) = additiv (ce-only byte-gleich, neuer id-Satz für Merges).
**6 Forks (entschieden):** ① Phasen derived-by-default + `<phases>`-Override · ② Träger = `comdare_experiment` · ③ `"CacheEngine"` = expliziter Prüfling `identity="self"` · ④ Merge-Default=replace, merge nur bei Override, fulljoin nur Phase 3 · ⑤ extend erlaubt (Obergrenze Registry-Angebot) · ⑥ K5-golden-Bruch → additiv (nichts bricht, s. §3.1).

## 5. Band-B-Reparatur (User: volle Freigabe + genehmigt)
**Reparierter Zuschnitt (sequentiell, EIN Planer-Owner):** **S4-KERN** → **Emitter-Paket** (D4 per-CEB `ceb:emit`) → **S5** P-VOLLZUG → **S6** 320er (USER-GO) → **S7** Hybrid+M-4+PDF → **S8** PDF-Abgabe (28.07.).
- **#19 (voller 5-tief-Resolver) löst sich in S4-KERN auf** (die Struktur, durch die die KERN-Semantik fließt). #19-Rest (numerische Ranges, `algo_version`-Angebot, Flag-Angebot) → **Band-C**.
- **§32-F8-3 ENTSCHIEDEN** (§49): Option 1+3, std::variant limitiert (nur abweichende Unter-Prüfdock-Verträge via Abstract-Factory; Haupt-Kommunikation statisch). S7 nur noch daten-gated.
- **§12-E11** in S4-KERN aufgelöst (E11-A: `<phases>` 1..unbounded).
- **golden-Klassifikation:** golden-gated = **allein S2/A1**; ganz Band-B golden-neutral (bestätigt durch §3.1-Klärung).

## 6. golden-Regen S2/A1 (User-GO: jetzt anstoßen)
- **Es ist ein VERIFIKATIONS-Fenster, kein Neu-Anker.** golden-CRC bleibt `0xF1C1F26A1232073B` (belegt: 17 CatalogAxes + `serialize_composition_path` byte-identisch seit `aa25c9a4`; P-OBS war rein diagnostisch, nie binary_id). Die golden/ABI-ctests liefen bereits grün im ce-development-Pipeline 11746 (`ca3e3a7e`).
- **Ketten-Nachweis getriggert + grün:** super-Pipeline `11751` (`COMDARE_BUILD_GOLDEN_N=true`, `COMDARE_GN_TOTAL=64`), `planer:delegate:success` — Emission-Kette Planer→CEB + Compile-golden-Anker (`static_assert==131072`) + §33-`--validate` auf korrekt gepinntem `ca3e3a7e`. 2 tier:build-Grandchildren pendeten auf Runner-Tags.
- **main-Lag (offen, Band-A-relevant):** ce `main` = `a87d6d5b`, **95 Commits hinter `development`**, ohne golden-Fixture. Der super-Orchestrate `trigger:cache-engine` fährt ce auf `branch: main` → golden/ABI-Verifikation über DIESEN Pfad testet Vor-golden-Stand. Vor Band-A muss ce `development`→`main` (nur merge, kein rebase) = der Band-A-Abgabe-Merge. **Timing-Entscheid steht aus.**

## 7. Runner-Tags (User-GO Weg a, 20.07.)
prod1-gitlab-runner mit Tags konfigurieren, die den Haupt-System-Achsen gerecht werden: **jede AVX512-Flag-Variante als EIGENES Tag**; Tags spiegeln die **echten** CPU-Fähigkeiten (nie raten, `/proc/cpuinfo`); Build = **UND-Bedingung** (Job läuft nur, wenn ALLE geforderten Haupt-System-Achsen-Tags am Runner = Maschine kann sie wirklich ausführen). Entblockt die pendenden tier:build-Grandchildren (S6-Vorbereitung). `Plan-RunnerTags` scoutet/plant; Manager setzt danach.

## 8. S3-Resolver-Aktivierung + Fehlplatzierungs-Scan (User-GO: sofort beheben)
- **Scan-Ergebnis:** genau EIN Fund — `cacheline_study.profile.xml:41/42/45` (Refs `isa`/`simd_extension`/`page_type` in Organ-Position → V-UNREG-AXIS). Alle anderen Profile sauber (0 V-CATEGORY).
- **Aktivierung risikofrei:** kein Konsument gatet auf `resolver.ok`; Default (`m3v2_study`)/CI (`all_axes_golden`) organ-rein → CI bleibt grün. Mechanik: 3 Registry-Pfade als CMake-Defines am Facade-Target + `read_axis_registry_trio` vor Director-Konstruktion (`profile_run_facade.cpp:584-619`).
- **Fix cacheline_study:** FP-1 `isa`→`target_isa` (System), FP-2 `simd_extension`→`extension_hardware/simd`, FP-3 `page_type` (build-only ohne Trio-Heimat → E-3). Offene Detail-Entscheide: E-1 (Reject HART vs. Annotation — Empf. Annotation zuerst), E-2 (cacheline_study noch live? kanonisieren vs. deprecaten), E-3 (page_type-Heimat).

## 9. Erteilte GOs (User 20.07.)
KERN-Plan + alle 6 Forks (konsolidiert + umsetzen) · S4 korrekt aufgelöst · Band-B volle Freigabe/genehmigt · prt-merge-golden-Relevanz bestätigt (§3.1) · golden-Regen jetzt anstoßen (getan, 11751) · Runner-Tags Weg (a) freigegeben · Persistierung #22 (einmalige Ausnahme, sinnvolle Auslegung) · Autoritäts-Regel (User-Beschreibung = Gesetz).

## 10. Task-Liste (User-sichtbares TODO)
#9 CI-Fix ✅ · #10 S2/A2 ✅ · #11 S2/A4 (super-CI läuft) · #12 S3 ✅ · #13 S2/A1 golden-Regen (Verifikation grün, schwere Materialisierung via Runner-Tags) · #14 S4-KERN · #15 S5 · #16 S6 (USER-GO) · #17 S7 · #18 S8 (28.07.) · #19 voller 5-tief-Resolver (→ in S4-KERN aufgelöst / Rest Band-C) · #20 S3-Aktivierung+Fix · #21 Band-B ✅ · #22 Persistierung (Ausnahme) · #23 Runner-Tags (Weg a).

## 11. Laufende Hintergrund-Threads
- `Plan-CoreSchema-Final` — finaler KERN-Bau-Plan (Spec-Gegenprüfung + Stempel/Storage/id-Satz).
- `Plan-RunnerTags` — prod1-Runner-Tag-Scout+Plan.
- Monitor `b9ap4q9dt` — S2/A4 super-CI.

## 12. Nächste Schritte (autonom, nach den Planern)
1. **Persistierung #22** (sinnvolle Auslegung): Ledger §-Eintrag + aktuelle Arch-Docs (14–23 + „in-eigenen-worten") + aktuelle Plan-Docs (v3.2/v2/ausführung + 19./20.07.-Baupläne). Keine Duplikate in superseded Codex-Dossiers.
2. **KERN-Bau** K1–K4/K6 + Stempel/Storage (golden-neutral) → K5-Emitter additiv.
3. **S3-Produktions-Aktivierung** + cacheline_study-Fix (nach E-2/E-3).
4. **Runner-Tags** setzen → schwere 2^17-Materialisierung entsperren.

## 13. Bindende Direktiven/Constraints (für Kontext-Übergabe)
Autonomie-Grant (ganzen v3.2-Plan durchziehen, auch nachts; innehalten nur bei nicht-ultracode-auflösbaren Entscheidungen). Je Paket ultracode-Plan → Opus-Impl → Manager-Verifikation. Fortschritt nur in neue Session-Docs; Ledger nur bei User-Technik (bzw. #22-Ausnahme). NIE rebase / immer fetch+merge vor Push. Remote-Löschung nur je-Repo-GO. Messdaten/Doku nie löschen (nur deprecaten). Secrets NIE printen/committen (PAT via Vault-grep). Dual-Remote (origin=gitlab.comdare.local, github=Sicherung). NIE AskUserQuestion (Klartext). Kein Python in Buildchain. ASCII-Code-Kommentare. golden-CRC `0xF1C1F26A1232073B`, ABI-Major 6, POD 56/layout 2. User-KERN-Beschreibung = autoritatives Gesetz (Abweichung = Regression).
