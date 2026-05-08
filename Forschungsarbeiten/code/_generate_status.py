"""Generiert STATUS.md fuer alle 33 Paper-Verzeichnisse."""
from pathlib import Path

ROOT = Path(__file__).parent

PAPERS = {
    "P01-ART": {
        "status": "CLONED",
        "repo": "unodb",
        "url": "https://github.com/laurynas-biveinis/unodb",
        "compiler": "C++17+",
        "desc": "Adaptive Radix Tree (Leis 2013) + OLC-Variante",
    },
    "P02-HOT": {
        "status": "CLONED",
        "repo": "hot",
        "url": "https://github.com/speedskater/hot",
        "compiler": "GCC 5+ (BMI2/AVX2)",
        "desc": "Height Optimized Trie (Binna 2018)",
    },
    "P03-Masstree": {
        "status": "CLONED",
        "repo": "masstree-beta",
        "url": "https://github.com/kohler/masstree-beta",
        "compiler": "GCC 4.6+",
        "desc": "Trie-of-B+-Trees (Mao 2012)",
    },
    "P04-CoCo-trie": {
        "status": "CLONED",
        "repo": "CoCo-trie",
        "url": "https://github.com/aboffa/CoCo-trie",
        "compiler": "GCC 11+ (C++20)",
        "desc": "Compressed Macro-Node Trie (Boffa 2024)",
    },
    "P05-START": {
        "status": "CLONED",
        "repo": "START",
        "url": "https://github.com/jungmair/START",
        "compiler": "GCC 7+",
        "desc": "Self-Tuning ART (Fent 2020)",
    },
    "P06-B2tree": {
        "status": "INSTITUTION_INTERN",
        "repo": "-",
        "url": "TUM Database Group (Kemper/Neumann/Leis)",
        "compiler": "GCC 9+",
        "desc": "B²-tree (Schmeisser 2022)",
    },
    "P07-Wormhole": {
        "status": "CLONED",
        "repo": "wormhole",
        "url": "https://github.com/wuxb45/wormhole",
        "compiler": "GCC 7+",
        "desc": "Hash+Trie+B+ Hybrid (Wu 2019)",
    },
    "P08-ARTSync": {
        "status": "INTEGRATED",
        "repo": "in P01 unodb",
        "url": "https://github.com/laurynas-biveinis/unodb",
        "compiler": "C++17+",
        "desc": "OLC-Variante in unodb (Leis 2016)",
    },
    "P09-Jacobson-LOUDS": {
        "status": "ORIGINAL_CONCEPT",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Original-LOUDS-Paper (Jacobson 1989); SDSL als moderne Referenz",
    },
    "P10-SuRF": {
        "status": "CLONED",
        "repo": "SuRF",
        "url": "https://github.com/efficient/SuRF",
        "compiler": "GCC 5+",
        "desc": "Fast Succinct Trie + Range Filter (Zhang 2018)",
    },
    "P11-CSS-tree": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "GCC 3.x",
        "desc": "Pre-Github (1999); Re-Implementation noetig",
    },
    "P12-CSB-tree": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "GCC 3.x",
        "desc": "Pre-Github (2000); Re-Implementation noetig",
    },
    "P13-Hankins-NodeSize": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "GCC 3.x",
        "desc": "Pre-Github (2003); Re-Implementation noetig",
    },
    "P14-Samuel-CSB-Conscious": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "GCC 4.x",
        "desc": "Pre-Github (2005); Re-Implementation noetig",
    },
    "P15-Graefe-Survey": {
        "status": "ORIGINAL_CONCEPT",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Survey-Paper Graefe/Larson 2001 ohne Code",
    },
    "P16-Bender-TreeLayout": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Theoretisches Paper (2002); Re-Implementation noetig",
    },
    "P17-Bender-CacheOblivious": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Theoretisches Paper (2005); Re-Implementation noetig",
    },
    "P18-Saikkonen-MultiLevel": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Pre-Github (2008); Re-Implementation noetig",
    },
    "P19-Saikkonen-LayoutInvariant": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Pre-Github (2016); Re-Implementation noetig",
    },
    "P20-BTreesAreBack": {
        "status": "CLONED",
        "repo": "leanstore",
        "url": "https://github.com/leanstore/leanstore",
        "compiler": "GCC 13+",
        "desc": "Adaptive B-Tree (Mueller 2025)",
    },
    "P21-Chen-PrefetchBPlus": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "GCC 3.x",
        "desc": "Pre-Github (2001); Re-Implementation noetig",
    },
    "P22-Chen-Fractal": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "GCC 3.x",
        "desc": "Pre-Github (2002); Re-Implementation noetig",
    },
    "P23-Khan-AdaptivePrefetch": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Kein public Code (2010); Re-Implementation noetig",
    },
    "P24-NaderanTahan": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Kein public Code (2016); Re-Implementation als Studie noetig",
    },
    "P25-Mahling-FillBuffer": {
        "status": "CLONED",
        "repo": "prefetching",
        "url": "https://github.com/hpides/prefetching",
        "compiler": "GCC 11+",
        "desc": "Prefetch Microbenchmarks (Mahling 2025)",
    },
    "P26-Zhang-FGCS-Prefetch": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Kein public Code (2024); Re-Implementation noetig",
    },
    "P27-Zhang-ASPLOS-Hierarchical": {
        "status": "LEGACY_REIMPL",
        "repo": "-",
        "url": "-",
        "compiler": "-",
        "desc": "Kein public Code (2025); Re-Implementation noetig",
    },
    "P28-Kuehn-DAMON": {
        "status": "INSTITUTION_INTERN",
        "repo": "-",
        "url": "TU Dortmund DBIS (Teubner)",
        "compiler": "GCC 9+",
        "desc": "Towards Data-Based Cache Optimization (Kuehn 2023)",
    },
    "P29-RCU-McKenney": {
        "status": "CLONED",
        "repo": "userspace-rcu",
        "url": "https://github.com/urcu/userspace-rcu",
        "compiler": "GCC 4+",
        "desc": "liburcu RCU-Implementation (McKenney 2001)",
    },
    "P30-Hazard-Pointers": {
        "status": "CLONED",
        "repo": "haz_ptr",
        "url": "https://github.com/huangjiahua/haz_ptr",
        "compiler": "C++17+",
        "desc": "Lightweight Hazard Pointers (Folly als Referenz)",
    },
    "P31-Ungethuem-TUD": {
        "status": "INSTITUTION_INTERN",
        "repo": "-",
        "url": "TU Dresden Habich",
        "compiler": "-",
        "desc": "Hardware Optimizations Survey (Ungethuem 2017); DIREKT bei Habich anfragen",
    },
    "P32-Schmidt-ToStride": {
        "status": "INSTITUTION_INTERN",
        "repo": "-",
        "url": "TU Dresden Habich",
        "compiler": "-",
        "desc": "To Stride or Not to Stride (Schmidt 2025); DIREKT bei Habich anfragen",
    },
    "P33-VAMPIR-SPP2377": {
        "status": "INSTITUTION_INTERN",
        "repo": "-",
        "url": "TU Dresden Habich/Lehner/Schirmeier (SPP2377)",
        "compiler": "-",
        "desc": "VAMPIR Kickoff-Poster (Berthold 2023); DIREKT bei Habich anfragen",
    },
}


def render_status(name, info):
    s = info["status"]
    body = [
        f"# {name} — Status",
        "",
        f"**Paper:** {info['desc']}",
        f"**Status:** {s}",
        f"**Verzeichnis:** `Forschungsarbeiten/code/{name}/`",
        "",
        "## Klon-/Implementierungs-Hinweis",
        "",
    ]
    if s == "CLONED":
        body += [
            f"- **Repository:** {info['url']}",
            f"- **Klon-Verzeichnis:** `{info['repo']}/`",
            f"- **Original-Compiler:** {info['compiler']}",
            "- **Klon-Datum:** 2026-05-04",
            f"- **Klon-Befehl:** `git clone --depth 1 {info['url']}`",
            "",
            "### Habich-Direktive (F-EXTRA-1)",
            "Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in",
            f"`comdare-cache-engine/adapters/{name}/`. Compiler-Layering: Originalcode-Bausteine",
            f"mit `{info['compiler']}` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.",
            "",
            "### Naechste Schritte (Phase 4.B)",
            f"1. Lizenz pruefen (`{info['repo']}/LICENSE` oder vergleichbar)",
            "2. Code-Struktur-Analyse: Welche Source-Files sind die Bausteine?",
            f"3. Adapter-Skelett in `comdare-cache-engine/adapters/{name}/`",
            f"4. Compiler-Provisioning verifizieren (`{info['compiler']}` verfuegbar?)",
        ]
    elif s == "INTEGRATED":
        body += [
            f"- **Status:** Code in einem ANDEREN Repository integriert: `{info['repo']}`",
            f"- **URL:** {info['url']}",
            f"- **Original-Compiler:** {info['compiler']}",
            "- **Klon-Verzeichnis:** verweist auf `P01-ART/unodb/` (OLC-Variante)",
            "",
            "### Hinweis",
            "Die ART-Sync-Variante (Leis 2016) ist als Optimistic-Lock-Coupling-Implementation",
            "direkt in unodb (P01) enthalten. Kein separates Repo noetig.",
        ]
    elif s == "ORIGINAL_CONCEPT":
        body += [
            "- **Status:** Originalpaper-Konzept ohne Code-Implementation",
            "- **Strategie:** Konzept als Referenz nutzen, ggf. Drittanbieter-Library als Anker",
            "",
        ]
        if name == "P09-Jacobson-LOUDS":
            body += [
                "### Drittanbieter-Referenz",
                "SDSL-Library (Succinct Data Structures Library) liefert eine moderne LOUDS-",
                "Implementation:",
                "- https://github.com/simongog/sdsl-lite",
                "",
                "Falls PRT-ART eine LOUDS-Page aufnehmen will, kann SDSL als externe",
                "Abhaengigkeit eingebunden werden (Apache-2.0-kompatibel zu pruefen).",
            ]
        elif name == "P15-Graefe-Survey":
            body += [
                "### Hinweis",
                "Survey-Paper enthaelt KEINEN Code, sondern Konzepte. Diese sind in das",
                "Cross-Paper-Konzept-Glossar (v3) eingearbeitet und in das Domaenenmodell",
                "geflossen. Kein separater Code noetig.",
            ]
    elif s == "LEGACY_REIMPL":
        body += [
            "- **Status:** Kein oeffentliches Repository verfuegbar",
            f"- **Original-Compiler:** {info['compiler']}",
            "- **Strategie:** Re-Implementation in PRT-ART (NICHT als Originalcode markiert)",
            "",
            "### Re-Implementation-Plan (Phase 4.B / Phase 5)",
            f"1. Original-Paper-Pseudocode in `prt_art/legacy_reimpl/{name}/` extrahieren",
            "2. C++23-Implementation des Algorithmus",
            "3. Code-Review mit Habich vor Integration",
            "4. Adapter zu Bausteine-Concept-Interface",
            "",
            "### Wichtig (Habich-Direktive)",
            'Diese Re-Implementation ist KEIN "Originalcode" im Sinne der Habich-Direktive.',
            "Sie ist eine **PRT-ART-eigene Implementation** des im Paper beschriebenen",
            "Algorithmus. Im Bausteine-Module-Identifier wird sie als",
            f"`legacy_reimpl_{name.lower()}` markiert (statt `ext_{name.lower()}`).",
        ]
    elif s == "INSTITUTION_INTERN":
        body += [
            "- **Status:** Code existiert vermutlich, ist aber INSTITUTION-INTERN",
            f"- **Institution:** {info['url']}",
            f"- **Original-Compiler:** {info['compiler']}",
            "- **Strategie:** Email-Anfrage an Autoren",
            "",
            "### Email-Anfrage-Strategie",
            "1. Vorformulierte Email mit Diplomarbeit-Kontext erstellen",
            "2. Habich (Hauptbetreuer) konsultieren",
            "3. Email an Autoren senden",
            f"4. Bei positivem Feedback: Code in `Forschungsarbeiten/code/{name}/` ablegen",
            "5. Lizenz-Klaerung VOR Integration in comdare-cache-engine",
            "",
            "### Falls Code nicht erhaeltlich",
            f"Re-Implementation in `prt_art/legacy_reimpl/{name}/` (siehe LEGACY_REIMPL-",
            "Strategie). Bei TUD-internen Quellen (P31/P32/P33): Direkter Habich-Kontakt",
            "KRITISCH, da diese Forschung in DIREKTER Habich-Linie steht.",
        ]
    body += ["", ""]
    return "\n".join(body)


written = 0
for dirname, info in PAPERS.items():
    target = ROOT / dirname / "STATUS.md"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(render_status(dirname, info), encoding="utf-8")
    written += 1

print(f"OK: {written} STATUS.md generiert.")
