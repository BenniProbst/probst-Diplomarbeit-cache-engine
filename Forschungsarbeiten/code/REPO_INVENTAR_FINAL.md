# Repo-Inventar FINAL — Originalcode der 33 Paper (Phase 2.B abgeschlossen)

**Phase 2.B** · TU Dresden Diplomarbeit PRT-ART
**Stand:** 2026-05-04
**Habich-Direktive:** Originalcode EXAKT KOPIERT uebernommen, Anbindung ueber Adapter-Pattern.
**F-EXTRA-1 (Compiler-Layering):** Hauptcompiler immer C++23; Bausteine mit Original-Compiler kompiliert + statisch in Modul-Wrapper gelinkt.

## Zusammenfassung

| Status | Anzahl | Anteil |
|--------|--------|--------|
| ✅ CLONED | 11 | 33% |
| 📦 ALT-OHNE-REPO (eigene Implementation noetig) | 14 | 42% |
| 🏛️ INSTITUTION-INTERN (TUD/HPI/Dortmund/SPP2377) | 6 | 18% |
| 📄 ORIGINALPAPER-KONZEPT (kein Code) | 2 | 6% |

## Detail-Tabelle

| P-ID | Paper | Repo / Status | Original-Compiler |
|------|-------|---------------|-------------------|
| P01 | ART (Leis 2013) | ✅ https://github.com/laurynas-biveinis/unodb | C++17+ (modern) |
| P02 | HOT (Binna 2018) | ✅ https://github.com/speedskater/hot | GCC 5+ (BMI2/AVX2) |
| P03 | Masstree (Mao 2012) | ✅ https://github.com/kohler/masstree-beta | GCC 4.6+ |
| P04 | CoCo-Trie (Boffa 2024) | ✅ https://github.com/aboffa/CoCo-trie | GCC 11+ (C++20) |
| P05 | START (Fent 2020) | ✅ https://github.com/jungmair/START | GCC 7+ |
| P06 | B²-tree (Schmeisser 2022) | 🏛️ TUM intern, kein Public Repo | GCC 9+ |
| P07 | Wormhole (Wu 2019) | ✅ https://github.com/wuxb45/wormhole | GCC 7+ |
| P08 | ARTSync (Leis 2016) | ✅ in unodb integriert (OLC-Variante) | C++17+ |
| P09 | Jacobson LOUDS (1989) | 📄 Originalpaper, kein Code | - |
| P10 | SuRF (Zhang 2018) | ✅ https://github.com/efficient/SuRF | GCC 5+ |
| P11 | CSS-tree (Rao/Ross 1999) | 📦 alt, kein Public Repo | GCC 3.x |
| P12 | CSB+-tree (Rao/Ross 2000) | 📦 alt, kein Public Repo | GCC 3.x |
| P13 | Hankins (2003) | 📦 alt, kein Public Repo | GCC 3.x |
| P14 | Samuel CSB-Conscious (2005) | 📦 alt, kein Public Repo | GCC 4.x |
| P15 | Graefe Survey (2001) | 📄 Survey-Paper, kein Code | - |
| P16 | Bender Tree Layout (2002) | 📦 alt, kein Public Repo | - |
| P17 | Bender Cache-Oblivious (2005) | 📦 alt, kein Public Repo | - |
| P18 | Saikkonen 2008 | 📦 kein Public Repo | - |
| P19 | Saikkonen 2016 | 📦 kein Public Repo | - |
| P20 | B-Trees Are Back (Mueller 2025) | ✅ https://github.com/leanstore/leanstore | GCC 13+ |
| P21 | Chen Prefetching B+ (2001) | 📦 alt, kein Public Repo | GCC 3.x |
| P22 | Chen Fractal (2002) | 📦 alt, kein Public Repo | GCC 3.x |
| P23 | Khan Adaptive Prefetch (2010) | 📦 kein Public Repo | - |
| P24 | NaderanTahan (2016) | 📦 kein Public Repo | - |
| P25 | Mahling Fill Buffer (2025) | ✅ https://github.com/hpides/prefetching | GCC 11+ |
| P26 | Zhang FGCS Prefetch (2024) | 📦 kein Public Repo | - |
| P27 | Zhang ASPLOS Hierarchical (2025) | 📦 kein Public Repo | - |
| P28 | Kuehn DAMON (2023) | 🏛️ TU Dortmund DBIS, kein Public Repo | GCC 9+ |
| P29 | RCU (McKenney 2001) | ✅ https://github.com/urcu/userspace-rcu | GCC 4+ |
| P30 | Hazard Pointers (Michael 2004) | ✅ https://github.com/huangjiahua/haz_ptr (folly als Referenz) | C++17+ |
| P31 | Ungethuem TUD (2017) | 🏛️ TUD intern, kein Public Repo | - |
| P32 | Schmidt To Stride (2025) | 🏛️ TUD intern, kein Public Repo | - |
| P33 | VAMPIR Poster (2023) | 🏛️ SPP2377 Projekt-Poster, kein Code | - |

## Geklonte Repos: Verzeichnisstruktur

```
Forschungsarbeiten/code/
├── P01-ART/unodb/                    (Adaptive Radix Tree + OLC)
├── P02-HOT/hot/                      (Height Optimized Trie)
├── P03-Masstree/masstree-beta/       (Trie-of-B+-Trees)
├── P04-CoCo-trie/CoCo-trie/          (Compressed Macro-Node-Trie)
├── P05-START/START/                  (Self-Tuning ART)
├── P07-Wormhole/wormhole/            (Hash+Trie+B+ Hybrid)
├── P10-SuRF/SuRF/                    (Fast Succinct Trie)
├── P20-BTreesAreBack/leanstore/      (Adaptive B-Tree)
├── P25-Mahling-FillBuffer/prefetching/ (Prefetch Microbenchmarks)
├── P29-RCU-McKenney/userspace-rcu/   (liburcu)
└── P30-Hazard-Pointers/haz_ptr/      (leichtgewichtige Hazard-Pointers)
```

## Kategorien-Erlaeuterung

### ✅ CLONED (11 Repos)
Originalcode-Repository erfolgreich geklont. Kann via Adapter-Pattern in
`comdare-cache-engine` integriert werden (Habich-Direktive: exakt kopiert).

### 📦 ALT-OHNE-REPO (14 Paper)
Pre-Github-Aera (vor ~2010) oder kein oeffentliches Repo verfuegbar. Fuer
diese Paper muss der Algorithmus aus dem Originalpaper RE-IMPLEMENTIERT
werden in PRT-ART. Diese Re-Implementation ist KEIN "Originalcode" im Sinne
der Habich-Direktive — sondern eine PRT-ART-eigene Implementation.

**Vorgehen pro Re-Implementation:**
- Implementation in `prt_art/legacy_reimpl/<paper>/` (statt `ext/<paper>/`)
- Original-Paper-Pseudocode 1:1 uebertragen
- Code-Review mit Habich vor Integration

### 🏛️ INSTITUTION-INTERN (6 Paper)
Code existiert vermutlich, ist aber nicht oeffentlich. Zugriff nur ueber
direkte Anfrage an Autoren. Strategie:

| P-ID | Institution | Kontakt-Empfehlung |
|------|-------------|--------------------|
| P06 B²-tree | TUM (Kemper/Neumann/Leis) | Email an Schmeisser/Schuele |
| P28 Kuehn DAMON | TU Dortmund DBIS (Teubner) | Email an Roland Kuehn |
| P31 Ungethuem TUD | TUD (Habich) | DIREKT bei Habich anfragen |
| P32 Schmidt To Stride | TUD (Habich) | DIREKT bei Habich anfragen |
| P33 VAMPIR | SPP2377 (Lehner/Schirmeier/Habich) | DIREKT bei Habich anfragen |

### 📄 ORIGINALPAPER-KONZEPT (2 Paper)
Paper liefert nur theoretisches Konzept, keine Implementation:
- **P09 Jacobson LOUDS (1989):** Original-LOUDS-Paper. Moderne Implementierungen
  in SDSL-Library. SDSL kann als Referenz integriert werden.
- **P15 Graefe Survey (2001):** Survey ueber B-Tree CPU-Cache-Optimierungen.
  Kein Code im Paper enthalten.

## Naechste Schritte (Phase 4.B Vorbereitung)

1. **Pro Repo Compiler-Verifikation:** Pruefen, ob der dokumentierte Compiler
   verfuegbar ist (z.B. GCC 11+ fuer P04 CoCo-Trie). Bei Bedarf
   Compiler-Provisioning anstossen (`tools/compiler_provisioning/`).

2. **Lizenz-Audit pro geklontem Repo:** Lizenz-Datei lesen, in
   `LIZENZEN_UEBERSICHT.md` zusammenfassen. Wichtig fuer Apache-2.0-
   Kompatibilitaet von `comdare-cache-engine`.

3. **Code-Struktur-Analyse pro Repo:** Welche Source-Dateien sind die
   "Bausteine" (Page/Node/Traversal)? Pro Repo eine `STRUKTUR_NOTIZ.md`.

4. **Re-Implementations-Plan fuer ALT-OHNE-REPO Paper:** Pseudocode aus
   den Papern extrahieren, Re-Implementation-Skelette anlegen.

5. **Email-Anfragen vorbereiten:** Pro 🏛️-Paper eine vorformulierte Email
   mit Diplomarbeit-Kontext + Anfrage nach Code-Zugang.

## Speicher-Footprint (geschaetzt)

| Repo | Groesse |
|------|---------|
| P01 unodb | ~5 MiB |
| P02 hot | ~10 MiB |
| P03 masstree-beta | ~5 MiB |
| P04 CoCo-trie | ~5 MiB |
| P05 START | ~5 MiB |
| P07 wormhole | ~3 MiB |
| P10 SuRF | ~5 MiB |
| P20 leanstore | ~30 MiB |
| P25 prefetching | ~5 MiB |
| P29 userspace-rcu | ~10 MiB |
| P30 haz_ptr | ~1 MiB |
| **Gesamt** | **~85 MiB** |

(Mit `--depth 1` clone reduziert auf etwa diese Werte.)
