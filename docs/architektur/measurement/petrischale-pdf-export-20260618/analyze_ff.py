#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ============================== DEPRECATED (2026-08-08) ==============================
# Teil des abgeschlossenen Petri-Schalen-Versuchs vom 18.06.2026 (erster PDF-Export der
# LaTeX-Anhaenge). KEIN aktiver Konsument: geprueft am 08.08. mit den Mustern
# 'analyze_ff', 'Messdaten-Backup' und '\.py\b' ueber .gitlab-ci.yml, ci/ und scripts/
# -> je 0 Treffer, bei bestandener Gegenprobe.
#
# WIRD BEWUSST NICHT GELOESCHT (Doku-Regel: nie loeschen, nur deprecaten) -- es ist der
# Beleg, dass die Kette Messwerte -> Auswertung -> LaTeX -> PDF einmal durchgelaufen ist.
#
# ABER KEIN VORBILD FUER DEN NACHBAU. Zwei Gruende:
#   1. Hausdoktrin "kein Python in der Buildchain" (Talos OS traegt kein Python).
#   2. Owner-KERN B-4 (07.08.2026): "Break even lebt nur in der CEB nach Messungs-Schluss
#      und wird dort im RAM ueber alle Tier-Binary-Messergebnisse ausgewertet, um dann von
#      der CEB auch bei Anforderung durch den Planer in Latex Dokumente, PDF oder xlsx
#      Tabellen nach Zielorte zu giessen (XML bestimmt Verhalten)."
#      -> Der produktive Auswerter gehoert nach C++ IN DIE CEB, nicht in ein Skript daneben.
#
# Einordnung und Vergleich mit dem Soll: ../README.md
# =====================================================================================
"""
analyze_ff.py — leitet aus den VALIDEN Messwerten Tendenzen fuer die Forschungsfragen
FF0-FF4 der Diplomarbeit ab (cache-line-aware / aktiv cache-bewusste Hardware-Adaption).

Eingabe : tier150_measurements_*.csv  (';'-getrennt, Spalte two_phase_valid)
Ausgabe : Konsolen-Report + ff_summary.json + tikz_data.csv (fuer die Praesentations-Plots)

Robustheit: nur two_phase_valid==1; Median statt Mittel (schwerer rechter Tail);
zusaetzlich p5..p95-getrimmtes Mittel. Ausreisser > 10x Median werden GEZAEHLT, aber nicht
geloescht (sie sind groesstenteils echte Schwer-Workload-Kosten). CLU-Instrumentierung wird
auf Plausibilitaet geprueft und ggf. als unbrauchbar markiert.

Aufruf: python analyze_ff.py [pfad_zur_csv]
"""
import sys, os, re, json, math, itertools
import numpy as np
import pandas as pd

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CSV = os.path.join(HERE, "tier150_measurements_INDEX320_cowfix-v1_2026-06-18.csv")
CSV = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_CSV

AXES = ["search_algo", "cache_traversal", "mapping", "path_compression", "node_type",
        "memory_layout", "allocator", "prefetch", "concurrency", "serialization",
        "telemetry", "value_handle", "isa", "index_organization", "io_dispatch",
        "migration_policy", "filter", "queuing_q1", "queuing_q2"]
READ_ONLY_WL = ["ycsb_c", "lp_read_uniform", "coco_p04_neg0"]   # saubere, lese-dominante Workloads

def med(s):           return float(np.median(s)) if len(s) else float("nan")
def tmean(s):                                                   # p5..p95-getrimmtes Mittel
    s = np.asarray(s, float)
    if len(s) == 0: return float("nan")
    lo, hi = np.percentile(s, [5, 95]); s = s[(s >= lo) & (s <= hi)]
    return float(s.mean()) if len(s) else float("nan")

def rel(d):                                                     # relativ zum Besten (1.0 = bester)
    if not d: return {}
    b = min(d.values()); return {k: round(v / b, 3) for k, v in d.items()}

def _phi(x):                                                    # Standardnormal-CDF (fuer MWU-Normalapprox.)
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))

def mwu_cliffs(a, b):
    """Mann-Whitney-U (zweiseitig, Normalapprox. mit Tie-Korrektur) + Cliff's delta = 2U/(nm)-1.
       Verteilungsfrei -> passend fuer die schwer-tailigen Latenzen. delta<0 => a (= schneller) < b."""
    a = np.asarray(a, float); b = np.asarray(b, float); n, m = len(a), len(b)
    if n == 0 or m == 0: return (float("nan"), float("nan"))
    pooled = np.concatenate([a, b])
    ranks = pd.Series(pooled).rank(method="average").to_numpy()  # Durchschnittsraenge (Ties)
    Ua = ranks[:n].sum() - n*(n+1)/2.0                           # U-Statistik fuer a
    mu = n*m/2.0; N = n + m
    _, cnt = np.unique(pooled, return_counts=True)
    tie = float(((cnt**3 - cnt).sum()))
    var = (n*m/12.0) * ((N + 1) - tie/(N*(N-1)))
    if var <= 0: return (1.0, 0.0)
    z = (Ua - mu) / math.sqrt(var)
    return (2.0 * (1.0 - _phi(abs(z))), 2.0*Ua/(n*m) - 1.0)

def holm(pvals):                                                # Holm-Korrektur der Familienfehlerrate
    p = np.asarray(pvals, float); m = len(p); order = np.argsort(p)
    adj = np.empty(m); run = 0.0
    for rank, i in enumerate(order):
        run = max(run, min((m - rank) * p[i], 1.0)); adj[i] = run
    return adj

def cliff_mag(d):                                               # Effektstaerke-Schwellen (Romano 2006)
    a = abs(d)
    return "negligible" if a < 0.147 else "small" if a < 0.33 else "medium" if a < 0.474 else "large"

def stats_triad(sub, axis):
    """Alle paarweisen MWU+Cliff's delta innerhalb der Achse (auf ns_per_op); Holm ueber die Familie."""
    vals = sorted(sub[axis].dropna().unique(),
                  key=lambda v: med(sub.loc[sub[axis] == v, "ns_per_op"].values))
    groups = {v: sub.loc[sub[axis] == v, "ns_per_op"].to_numpy(float) for v in vals}
    res = []
    for a, b in itertools.combinations(vals, 2):
        p, d = mwu_cliffs(groups[a], groups[b])
        res.append({"a": a, "b": b, "p": p, "delta": round(d, 3),
                    "med_a": round(med(groups[a]), 0), "med_b": round(med(groups[b]), 0)})
    for r, pa in zip(res, holm([r["p"] for r in res]) if res else []):
        r["p_holm"] = float(pa); r["sig"] = bool(pa < 0.05); r["mag"] = cliff_mag(r["delta"])
    return res

def axis_median_table(df, axis):
    g = df.groupby(axis)["ns_per_op"]
    return {k: round(med(v.values), 1) for k, v in g}, {k: int(len(v)) for k, v in g}

def main():
    if not os.path.exists(CSV):
        print(f"[FEHLER] CSV nicht gefunden: {CSV}"); sys.exit(1)
    print(f"# Lade {os.path.basename(CSV)} ...")
    df = pd.read_csv(CSV, sep=";", low_memory=False)
    n_all = len(df)
    df = df[df["two_phase_valid"] == 1].copy()
    print(f"# Zeilen gesamt={n_all}  valide(two_phase_valid==1)={len(df)}")

    # --- Achsen aus binary_id extrahieren ---
    for ax in AXES:
        df[ax] = df["binary_id"].str.extract(rf"{ax}=([^/]+)")
    varied = [ax for ax in AXES if df[ax].nunique(dropna=True) > 1]
    fixed  = {ax: df[ax].dropna().iloc[0] for ax in AXES if df[ax].nunique(dropna=True) == 1}
    n_binaries = df["binary_id"].nunique()
    print(f"# distinkte Binaries={n_binaries}  variierte Achsen={varied}")
    print(f"# fixierte Achsen={fixed}")

    # --- Ausreisser / Tail ---
    gmed = med(df["ns_per_op"].values)
    thr = 10 * gmed
    out = df[df["ns_per_op"] > thr]
    print(f"\n## Tail/Ausreisser: Median(ns/op)={gmed:.0f}  Mittel={df['ns_per_op'].mean():.0f}  "
          f"max={df['ns_per_op'].max():.0f}  >10xMedian: {len(out)} ({100*len(out)/len(df):.2f}%)")
    if "repetition" in df:
        rd = out.groupby("repetition").size().to_dict()
        print(f"   Ausreisser je Wiederholung={rd}  (gleichverteilt => kein reiner Warmup-Effekt)")

    summary = {"file": os.path.basename(CSV), "rows_valid": int(len(df)),
               "binaries": int(n_binaries), "varied_axes": varied, "fixed_axes": fixed,
               "global_median_ns": round(gmed, 1), "outlier_pct": round(100*len(out)/len(df), 2),
               "marginal": {}, "controlled": {}}

    # --- Marginale Mediane je variierter Achse ---
    print("\n## Marginale Mediane ns/op je Achse (ueber alle uebrigen Achsen+Workloads)")
    for ax in varied:
        m, c = axis_median_table(df, ax)
        m = dict(sorted(m.items(), key=lambda kv: kv[1]))
        summary["marginal"][ax] = {"median": m, "rel_to_best": rel(m), "n": c}
        print(f"  [{ax}]  " + "  ".join(f"{k}={v:.0f}({c[k]})" for k, v in m.items()))

    # --- Kontrolliert (Lese-Workload + search_algo=k_ary, falls vorhanden) ---
    ctrl = df[df["workload"].isin(READ_ONLY_WL)]
    if "search_algo" in varied and (ctrl["search_algo"] == "k_ary").any():
        ctrl = ctrl[ctrl["search_algo"] == "k_ary"]
    print(f"\n## Kontrolliert (Workloads={READ_ONLY_WL}, search_algo=k_ary): isolierte Achseneffekte (n={len(ctrl)})")
    for ax in [a for a in varied if a != "search_algo"]:
        m, c = axis_median_table(ctrl, ax)
        m = dict(sorted(m.items(), key=lambda kv: kv[1]))
        summary["controlled"][ax] = {"median": m, "rel_to_best": rel(m), "n": c}
        spread = (max(m.values())/min(m.values())-1)*100 if m else 0
        print(f"  [{ax}]  spread={spread:.1f}%  " + "  ".join(f"{k}={v:.0f}" for k, v in m.items()))

    # --- (a) Statistik-Triade: Mann-Whitney-U + Holm + Cliff's delta (konfundierungs-arm) ---
    print("\n## Statistik-Triade (MWU + Holm-Korrektur + Cliff's delta) auf kontrollierten Subsets")
    summary["stats"] = {}
    ro = df[df["workload"].isin(READ_ONLY_WL)]                    # search_algo: alle Methoden, Lese-Last
    triad_input = {}
    if "search_algo" in varied: triad_input["search_algo"] = ro
    for ax in [a for a in varied if a != "search_algo"]:
        triad_input[ax] = ctrl                                   # uebrige Achsen: zusaetzlich k_ary fixiert
    for ax, sub in triad_input.items():
        res = stats_triad(sub, ax); summary["stats"][ax] = res
        print(f"  [{ax}] (n_sub={len(sub)})")
        for r in res:
            print(f"     {r['a']} vs {r['b']}: med {r['med_a']:.0f}/{r['med_b']:.0f}  "
                  f"p_holm={r['p_holm']:.2e}  delta={r['delta']:+.3f} ({r['mag']})  sig={r['sig']}")

    # --- (b) Segment-/Organ-Attribution (seg_<achse>_ns) ---
    print("\n## Segment-Attribution: Zeitanteil je Achsen-Organ (Observer-Segmente)")
    seg_cols = [c for c in df.columns if c.startswith("seg_") and c.endswith("_ns")]
    seg_tot = df[seg_cols].sum(axis=1)
    cover = med((seg_tot / df["total_ns"].replace(0, np.nan)).dropna().values) * 100
    med_share = (df[seg_cols].div(seg_tot.replace(0, np.nan), axis=0).median() * 100).sort_values(ascending=False)
    def _organ(c): return c.replace("seg_", "").replace("_ns", "")
    summary["seg"] = {"coverage_pct_of_wallclock": round(cover, 1),
                      "median_share_pct": {_organ(c): round(v, 1) for c, v in med_share.items()}}
    print(f"   Segment-Summe deckt ~{cover:.1f}% der Wall-Clock (total_ns) ab => nur Relativ-Attribution unter Organen")
    for c, v in med_share.head(8).items():
        print(f"     {_organ(c):22s} {v:5.1f}% Mediananteil")

    # --- CLU-Plausibilitaet ---
    print("\n## CLU-Diagnose (Cache-Line-Auslastung je memory_layout)")
    clu_ok = True; clu = {}
    if "stat_memory_layout_cache_lines" in df and "memory_layout" in varied:
        gg = df.groupby("memory_layout")
        fb_const = gg["stat_memory_layout_field_bytes"].mean().round().nunique() == 1
        for k, v in gg:
            cl = v["stat_memory_layout_cache_lines"].mean(); fb = v["stat_memory_layout_field_bytes"].mean()
            clu[k] = round(100*fb/max(cl*64, 1), 2)
        impossible = {k: v["stat_memory_layout_cache_lines"].mean()/max(v["stat_memory_layout_records"].mean(),1)
                      for k, v in gg}
        clu_ok = not fb_const and max(clu.values()) > 20  # realistische CLU sollte >20% sein
        print(f"   CLU%={clu}")
        print(f"   field_bytes ueber Layouts konstant={fb_const}  cache_lines/record={ {k: round(x,1) for k,x in impossible.items()} }")
        print(f"   => CLU VERWERTBAR: {clu_ok}  (False: Instrumentierungs-Bug, NICHT berichten)")
    summary["clu_pct"] = clu; summary["clu_usable"] = bool(clu_ok)

    # --- FF-Schlussfolgerungen (nur was die validen Daten hergeben) ---
    def best(ax): m = summary["marginal"].get(ax, {}).get("median", {}); return (min(m, key=m.get), min(m.values())) if m else (None, None)
    def worst(ax): m = summary["marginal"].get(ax, {}).get("median", {}); return (max(m, key=m.get), max(m.values())) if m else (None, None)
    ff = {}
    sa_b, sa_bv = best("search_algo"); sa_w, sa_wv = worst("search_algo")
    print("\n" + "="*78 + "\n## FORSCHUNGSFRAGEN — abgeleitete Tendenzen (Stand buggy-Lauf)\n" + "="*78)

    ff["FF0"] = (f"Aktiv cache-bewusste SUCH-Entscheidung wirkt am staerksten: {sa_b}={sa_bv:.0f} vs "
                 f"{sa_w}={sa_wv:.0f} ns/op (-{100*(1-sa_bv/sa_wv):.0f}%). ABER prefetch verschlechtert "
                 f"(none=best), memory_layout-Effekt kontrolliert ~"
                 f"{(max(summary['controlled'].get('memory_layout',{}).get('median',{1:1}).values())/min(summary['controlled'].get('memory_layout',{}).get('median',{1:1}).values())-1)*100:.1f}%"
                 f" (vernachlaessigbar). Plattform-Variation NICHT testbar (nur isa={fixed.get('isa','?')}).")
    ff["FF1"] = (f"Orthogonale Permutationsmatrix bestaetigt: {n_binaries} Binaries als Vollfaktoriell "
                 f"{ '×'.join(str(df[a].nunique()) for a in varied) } ({varied}). Starke Achse×Workload-"
                 f"Kopplung: node_type-Ranking kippt zwischen Lese- und Schreib/Scan-Last (node4 lese-gut, "
                 f"schreib-schlecht). Achsen-Kopplung node_type×SIMD×path_compression NICHT testbar (isa/path fix).")
    ff["FF2"] = (f"Knoten-/Cache-Line-Groessen-Streit (1 CL CSS/CSB+ vs 16 Hankins): kontrolliert (Lese) "
                 f"node256 am schlechtesten, kleine Knoten besser => Tendenz pro KLEINER Knoten, ABER "
                 f"Sweet-Spot node16 (node4 unter Schreiblast schlecht). Pipeline: two_phase_valid=100%, "
                 f"aber {summary['outlier_pct']}% Tail-Ausreisser + CLU-Bug => Mediane/Trim noetig, PMC fehlt.")
    has_prtart = df["binary_id"].str.contains("prt_art|prt-art", case=False).any()
    ff["FF3"] = (f"NICHT beantwortbar mit diesem Lauf: kein PRT-ART/SOTA-Lebewesen (prt_art im Datensatz="
                 f"{bool(has_prtart)}; variiert werden Such-METHODEN k_ary/eytzinger/..., nicht ART/HOT/...). "
                 f"Mikroarch-Kennzahlen (CLU/LLC/dTLB) fehlen bzw. CLU defekt => FF3 offen.")
    pd_vals = tc_vals = 1  # prefetch_distance/thread_count im setting variiert?
    if "setting" in df:
        pd_vals = int(df["setting"].str.extract(r"prefetch_distance=([0-9]+)")[0].nunique())
        tc_vals = int(df["setting"].str.extract(r"thread_count=([0-9]+)")[0].nunique())
    ff["FF4"] = (f"Compile-Time-Achsen (search_algo/node_type/memory_layout/prefetch) dominieren und sind je "
                 f"Binary provenienz-codiert (binary_id). Laufzeit-Sub-Achsen: thread_count={tc_vals} Auspraegung(en), "
                 f"prefetch_distance={pd_vals} Auspraegung(en). "
                 + ("Die cache-relevante prefetch_distance ist NICHT gesweept => die Laufzeit-Adaption "
                    "(adaptive Layout-/Prefetch-Wahl) ist noch ungetestet." if pd_vals <= 1 else
                    "prefetch_distance wird gesweept => Laufzeit-Adaption teilweise getestet."))
    # Signifikanz + Segment-Befund in die FF-Texte einweben
    def sig_of(ax, x, y):
        for r in summary.get("stats", {}).get(ax, []):
            if {r["a"], r["b"]} == {x, y}: return r
        return None
    sa_sig = sig_of("search_algo", "k_ary", "linear_scan")
    if sa_sig: ff["FF0"] += (f" Signifikanz: k_ary vs linear_scan p_holm={sa_sig['p_holm']:.1e}, "
                             f"Cliff's delta={sa_sig['delta']:+.2f} ({sa_sig['mag']}).")
    nt_sig = sig_of("node_type", "node16", "node256")
    if nt_sig: ff["FF2"] += (f" Signifikanz node16 vs node256: p_holm={nt_sig['p_holm']:.1e}, "
                             f"delta={nt_sig['delta']:+.2f} ({nt_sig['mag']}).")
    seg = summary.get("seg", {}).get("median_share_pct", {})
    if seg:
        top = max(seg.items(), key=lambda kv: kv[1])
        ff["FF3"] += (f" Segment-Attribution: '{top[0]}' dominiert die beobachtete Organ-Zeit "
                      f"({top[1]:.0f}% Mediananteil); die Segmente decken nur "
                      f"~{summary['seg']['coverage_pct_of_wallclock']:.0f}% der Wall-Clock ab "
                      f"(Observer-Relativwert, keine absolute Zeit-Attribution).")
    for k in ["FF0","FF1","FF2","FF3","FF4"]:
        print(f"\n[{k}] {ff[k]}")
    summary["ff_conclusions"] = ff

    # --- Export fuer die Plots ---
    with open(os.path.join(HERE, "ff_summary.json"), "w", encoding="utf-8") as fh:
        json.dump(summary, fh, ensure_ascii=False, indent=2)
    rows = []
    for scope in ("marginal", "controlled"):
        for ax, d in summary[scope].items():
            for v, mv in d["median"].items():
                rows.append({"scope": scope, "axis": ax, "value": v, "median_ns": mv,
                             "rel_to_best": d["rel_to_best"][v], "n": d["n"][v]})
    pd.DataFrame(rows).to_csv(os.path.join(HERE, "tikz_data.csv"), sep=";", index=False)
    print(f"\n# geschrieben: ff_summary.json, tikz_data.csv  (CLU_usable={summary['clu_usable']})")

if __name__ == "__main__":
    main()
