# Repo-Inventar — Originalcode der 33 Paper

**Phase 2.B** · TU Dresden Diplomarbeit PRT-ART
**Stand:** 2026-05-04
**Habich-Direktive:** Originalcode EXAKT KOPIERT uebernommen, Anbindung ueber Adapter-Pattern.
**F-EXTRA-1 (Compiler-Layering):** Hauptcompiler immer C++23; Bausteine mit Original-Compiler kompiliert + statisch in Modul-Wrapper gelinkt.

## Status-Codes

| Code | Bedeutung |
|------|-----------|
| ✅ CLONED | Repo erfolgreich geklont |
| 🔍 SEARCH | URL muss recherchiert werden |
| ❌ NO-REPO | Kein oeffentliches Repo (Originalpaper-Konzept oder altes Paper) |
| ⏳ MANUAL | Manueller Download noetig (z.B. Mail an Autor) |
| 🌟 OWN-IMPL | Eigene Implementation noetig (kein Originalcode verfuegbar) |

## Inventar

| P-ID | Paper | Repo-URL | Original-Compiler (vorlaeufig) | Status |
|------|-------|----------|--------------------------------|--------|
| P01 | ART (Leis 2013) | https://github.com/wangziqi2013/ART | GCC 4.7+ | 🔍 |
| P02 | HOT (Binna 2018) | https://github.com/speedskater/hot | GCC 5+ (BMI2/AVX2) | 🔍 |
| P03 | Masstree (Mao 2012) | https://github.com/kohler/masstree-beta | GCC 4.6+ | 🔍 |
| P04 | CoCo-Trie (Boffa 2024) | https://github.com/aboffa/CoCo-trie | GCC 11+ (C++20) | 🔍 |
| P05 | START (Fent 2020) | (TUM, vermutlich nicht public) | GCC 7+ | 🔍 |
| P06 | B²-tree (Schmeisser 2022) | (TUM, vermutlich nicht public) | GCC 9+ | 🔍 |
| P07 | Wormhole (Wu 2019) | https://github.com/wuxb45/wormhole | GCC 7+ | 🔍 |
| P08 | ARTSync (Leis 2016) | (in P01-Repo integriert?) | GCC 5+ | 🔍 |
| P09 | Jacobson LOUDS (1989) | - (Originalpaper, kein Repo) | - | ❌ |
| P10 | SuRF (Zhang 2018) | https://github.com/efficient/SuRF | GCC 5+ | 🔍 |
| P11 | CSS-tree (Rao/Ross 1999) | (alt, kein Repo bekannt) | GCC 3.x | ❌/🌟 |
| P12 | CSB+-tree (Rao/Ross 2000) | (alt, kein Repo bekannt) | GCC 3.x | ❌/🌟 |
| P13 | Hankins (2003) | (alt, kein Repo bekannt) | GCC 3.x | ❌/🌟 |
| P14 | Samuel CSB-Conscious (2005) | (alt, kein Repo bekannt) | GCC 4.x | ❌/🌟 |
| P15 | Graefe Survey (2001) | - (Survey, kein Code) | - | ❌ |
| P16 | Bender Tree Layout (2002) | (kein Repo bekannt) | - | ❌/🌟 |
| P17 | Bender Cache-Oblivious (2005) | (kein Repo bekannt) | - | ❌/🌟 |
| P18 | Saikkonen 2008 | (kein Repo bekannt) | - | ❌/🌟 |
| P19 | Saikkonen 2016 | (kein Repo bekannt) | - | ❌/🌟 |
| P20 | B-Trees Are Back (Mueller 2025) | https://github.com/leanstore/...? | GCC 13+ (C++23) | 🔍 |
| P21 | Chen Prefetching B+ (2001) | (alt, kein Repo bekannt) | GCC 3.x | ❌/🌟 |
| P22 | Chen Fractal (2002) | (alt, kein Repo bekannt) | GCC 3.x | ❌/🌟 |
| P23 | Khan Adaptive Prefetch (2010) | (kein Repo bekannt) | - | ❌/🌟 |
| P24 | NaderanTahan (2016) | (kein Repo bekannt) | - | ❌ |
| P25 | Mahling Fill Buffer (2025) | (HPI, vermutlich) | GCC 11+ | 🔍 |
| P26 | Zhang FGCS Prefetch (2024) | (vermutlich kein Repo) | - | 🔍 |
| P27 | Zhang ASPLOS Hierarchical (2025) | (vermutlich kein Repo) | - | 🔍 |
| P28 | Kuehn DAMON (2023) | (TU Dortmund, vermutlich) | GCC 9+ | 🔍 |
| P29 | RCU (McKenney 2001) | https://github.com/urcu/userspace-rcu | GCC 4+ | 🔍 |
| P30 | Hazard Pointers (Michael 2004) | (Originalpaper-Konzept; folly als ref) | - | ❌/🌟 |
| P31 | Ungethuem TUD (2017) | (TUD, vermutlich nicht public) | - | 🔍 |
| P32 | Schmidt To Stride (2025) | (TUD, vermutlich nicht public) | - | 🔍 |
| P33 | VAMPIR Poster (2023) | (SPP2377 Projekt, kein Code) | - | ❌ |

## Vorgehen

1. **Klonen-Phase 1:** Hochkonfidente Repos parallel klonen (P02, P03, P04, P07, P10, P29).
2. **Recherche-Phase:** Unklare Repos via WebSearch verifizieren (P01, P05, P06, P08, P20, P25, P28, P31, P32).
3. **Notiz-Phase:** Bei nicht-vorhandenen Repos eine `NO_REPO.md` mit Begruendung pro Paper.
4. **Pro Paper:** README.md mit Original-Compiler-Anforderung + Klon-Datum + Lizenz-Hinweis.

## Hinweis zur Lizenzpflicht

Pro `ext/<paper>/` (im comdare-cache-engine-Projekt) wird die Originallizenz beibehalten. Dieses Inventar ist nur zur Vorbereitung — die endgueltige Integration erfolgt in Phase 4.B (Projekt-Setup).
