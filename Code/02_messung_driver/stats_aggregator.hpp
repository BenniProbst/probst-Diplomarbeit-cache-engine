// SPDX-License-Identifier: Apache-2.0
// V41.B3 (2026-05-25) - Statistik-Aggregator fuer Plugin-Mikrobenchmarks
//
// Pro Permutation N Runs -> mean, stddev, sem, 95%-CI.
// Paarweiser Welch's t-Test zwischen Permutationen.
//
// Nutzt cache-engine welch_t_test.hpp (V33.A.3, Numerical Recipes Lentz-Algo).

#pragma once

// V41.B3: welch_t_test.hpp aus cache-engine (include-path via target_include_directories)
#include <cache_engine/builder/commands/welch_t_test.hpp>

// V41.G.1: Achsen-Baum-Parser für per-Achsen-CSV-Spalten.
#include "axis_tree.hpp"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <numeric>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::messung_driver {

struct PermStats {
    std::string permutation_id;
    std::string subsystem;
    std::string axes;
    std::string version;
    std::size_t n_runs{0};
    double      mean_us{0.0};
    double      stddev{0.0};
    double      sem{0.0};     // standard error of mean = stddev/sqrt(n)
    double      ci_low{0.0};  // 95%-CI lower
    double      ci_high{0.0}; // 95%-CI upper
    double      min_us{0.0};
    double      max_us{0.0};
};

// Student-t (zweiseitiges 95%-Quantil) approximiert per Welch-Satterthwaite-
// Inversion ueber den welch_t_test-Code: hier hartcodierte t_{0.025,df} fuer
// kleine N (Tabelle), Fallback ~1.96 fuer grosses N.
inline double t_critical_95(std::size_t n) {
    if (n < 2) return 0.0;
    // Quantile df -> t_{0.025, df}
    static constexpr struct {
        std::size_t df;
        double      t;
    } kTable[] = {
        {1, 12.706}, {2, 4.303},  {3, 3.182},   {4, 2.776},   {5, 2.571},   {6, 2.447},
        {7, 2.365},  {8, 2.306},  {9, 2.262},   {10, 2.228},  {15, 2.131},  {20, 2.086},
        {30, 2.042}, {50, 2.009}, {100, 1.984}, {200, 1.972}, {500, 1.965}, {1000, 1.962},
    };
    std::size_t df = n - 1;
    for (auto const& e : kTable) {
        if (df <= e.df) return e.t;
    }
    return 1.96;
}

[[nodiscard]] inline PermStats compute_stats(std::string_view perm_id, std::string_view subsystem,
                                             std::string_view axes, std::string_view version,
                                             std::span<const double> samples_us) {
    PermStats s{};
    s.permutation_id = perm_id;
    s.subsystem      = subsystem;
    s.axes           = axes;
    s.version        = version;
    s.n_runs         = samples_us.size();
    if (samples_us.empty()) return s;

    double sum = std::accumulate(samples_us.begin(), samples_us.end(), 0.0);
    s.mean_us  = sum / static_cast<double>(s.n_runs);

    double sq = 0.0;
    for (double v : samples_us) {
        double d = v - s.mean_us;
        sq += d * d;
    }
    if (s.n_runs >= 2) {
        double var = sq / static_cast<double>(s.n_runs - 1);
        s.stddev   = std::sqrt(var);
        s.sem      = s.stddev / std::sqrt(static_cast<double>(s.n_runs));
        double t   = t_critical_95(s.n_runs);
        s.ci_low   = s.mean_us - t * s.sem;
        s.ci_high  = s.mean_us + t * s.sem;
    } else {
        s.ci_low  = s.mean_us;
        s.ci_high = s.mean_us;
    }
    auto [mn, mx] = std::minmax_element(samples_us.begin(), samples_us.end());
    s.min_us      = *mn;
    s.max_us      = *mx;
    return s;
}

// Welch's t-test ueber Mikrosekunden-Samples (cache-engine erwartet int64).
// Konvertiere us -> ns int64 fuer numerische Stabilitaet.
inline cache_engine::builder::commands::stats::WelchResult welch_us(std::span<const double> a_us,
                                                                    std::span<const double> b_us) {
    std::vector<std::int64_t> a_ns, b_ns;
    a_ns.reserve(a_us.size());
    b_ns.reserve(b_us.size());
    for (double v : a_us) a_ns.push_back(static_cast<std::int64_t>(v * 1000.0));
    for (double v : b_us) b_ns.push_back(static_cast<std::int64_t>(v * 1000.0));
    return cache_engine::builder::commands::stats::welch_t_test(std::span<const std::int64_t>(a_ns),
                                                                std::span<const std::int64_t>(b_ns));
}

inline void write_stats_csv(std::filesystem::path const& path, std::span<const PermStats> stats) {
    std::filesystem::create_directories(path.parent_path());
    std::ofstream f(path);
    f << "permutation_id,subsystem,axes,version,n_runs,mean_us,stddev_us,sem_us,ci95_low,ci95_high,min_us,max_us\n";
    for (auto const& s : stats) {
        f << s.permutation_id << ',' << s.subsystem << ",\"" << s.axes << "\"," << s.version << ',' << s.n_runs << ','
          << s.mean_us << ',' << s.stddev << ',' << s.sem << ',' << s.ci_low << ',' << s.ci_high << ',' << s.min_us
          << ',' << s.max_us << '\n';
    }
}

// V41.G.1 — per-Achsen-Spalten-CSV: zerlegt die `axes`-Sammelspalte in EINE Spalte je Achsen-Schlüssel
// (z.B. simd,layout,alloc), sodass die Auswertung pro Achsen-Ebene auf-/absteigen kann.
inline void write_stats_csv_per_axis(std::filesystem::path const& path, std::span<const PermStats> stats,
                                     std::vector<std::string> const& axis_keys) {
    std::filesystem::create_directories(path.parent_path());
    std::ofstream f(path);
    f << "permutation_id,subsystem";
    for (auto const& k : axis_keys) f << ',' << k;
    f << ",version,n_runs,mean_us,stddev_us,sem_us,ci95_low,ci95_high,min_us,max_us\n";
    for (auto const& s : stats) {
        auto const kv = parse_axes(s.axes);
        f << s.permutation_id << ',' << s.subsystem;
        for (auto const& k : axis_keys) { f << ",\"" << axis_value(kv, k).value_or("") << '"'; }
        f << ',' << s.version << ',' << s.n_runs << ',' << s.mean_us << ',' << s.stddev << ',' << s.sem << ','
          << s.ci_low << ',' << s.ci_high << ',' << s.min_us << ',' << s.max_us << '\n';
    }
}

struct PairwiseRow {
    std::string a;
    std::string b;
    double      mean_a{};
    double      mean_b{};
    double      delta{};
    double      t_stat{};
    double      df{};
    double      p_value{};
    bool        significant_5pc{};
    // V41.G.1 — Achsen-Subtree-Kontext: welche Achse variiert, bei welchem fixierten Rest.
    std::string varying_axis;  // z.B. "alloc"
    std::string fixed_context; // z.B. "simd=avx2;layout=soa"
};

inline void write_pairwise_csv(std::filesystem::path const& path, std::span<const PairwiseRow> rows) {
    std::filesystem::create_directories(path.parent_path());
    std::ofstream f(path);
    // V41.G.1: varying_axis + fixed_context-Spalten ergänzt (Subtree-restringierte Vergleiche).
    f << "perm_a,perm_b,varying_axis,fixed_context,mean_a_us,mean_b_us,delta_us,"
         "t_statistic,df,p_value,significant_5pc\n";
    for (auto const& r : rows) {
        f << r.a << ',' << r.b << ',' << r.varying_axis << ",\"" << r.fixed_context << "\"," << r.mean_a << ','
          << r.mean_b << ',' << r.delta << ',' << r.t_stat << ',' << r.df << ',' << r.p_value << ','
          << (r.significant_5pc ? 1 : 0) << '\n';
    }
}

} // namespace comdare::messung_driver
