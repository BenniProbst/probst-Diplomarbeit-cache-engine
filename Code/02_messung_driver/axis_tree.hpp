// SPDX-License-Identifier: Apache-2.0
// V41.G.1 (2026-05-31) — Hierarchische Achsen-Iteration + Auswertung.
//
// Der Plugin-Loader liefert eine FLACHE Permutationsliste; ihr `axes`-String kodiert aber einen
// Achsen-Baum (Format aus permutation_codegen: "simd=avx2,layout=soa,alloc=std (real=mimalloc)").
// Dieser Header parst den String + baut daraus den hierarchischen Achsen-Baum, über den der
// messung_driver gruppiert ausgibt, per-Achsen-CSV-Spalten schreibt und Welch-Vergleiche auf
// Achsen-Subtrees (gleiche Fix-Achsen, EINE variierende Achse) restringiert.
//
// Pure (nur std) → unit-testbar ohne Plugin-Loading.

#pragma once

#include <algorithm>
#include <cstddef>
#include <map>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::messung_driver {

// Ein geparstes Achsen-Schlüssel/Wert-Paar (z.B. {"simd","avx2"}).
struct AxisKV {
    std::string key;
    std::string value;
};

namespace detail {
[[nodiscard]] inline std::string trim(std::string_view s) {
    std::size_t const a = s.find_first_not_of(" \t");
    if (a == std::string_view::npos) return std::string{};
    std::size_t const b = s.find_last_not_of(" \t");
    return std::string{s.substr(a, b - a + 1)};
}
}  // namespace detail

// Parst den codegen-`axes`-String in geordnete Achsen-Paare.
// "simd=avx2,layout=soa,alloc=std (real=mimalloc)"
//   → [{simd,avx2}, {layout,soa}, {alloc,"std (real=mimalloc)"}]
// Tokens ohne '=' werden als positionale Werte (leerer Key) aufgenommen.
[[nodiscard]] inline std::vector<AxisKV> parse_axes(std::string_view axes) {
    std::vector<AxisKV> out;
    std::size_t pos = 0;
    while (pos <= axes.size()) {
        std::size_t const comma = axes.find(',', pos);
        std::string_view const tok =
            axes.substr(pos, comma == std::string_view::npos ? std::string_view::npos : comma - pos);
        std::string const t = detail::trim(tok);
        if (!t.empty()) {
            std::size_t const eq = t.find('=');
            if (eq != std::string::npos) {
                out.push_back({detail::trim(std::string_view{t}.substr(0, eq)),
                               detail::trim(std::string_view{t}.substr(eq + 1))});
            } else {
                out.push_back({std::string{}, t});
            }
        }
        if (comma == std::string_view::npos) break;
        pos = comma + 1;
    }
    return out;
}

// Wert einer benannten Achse (falls vorhanden).
[[nodiscard]] inline std::optional<std::string>
axis_value(std::vector<AxisKV> const& axes, std::string_view key) {
    for (auto const& kv : axes) {
        if (kv.key == key) return kv.value;
    }
    return std::nullopt;
}

// Generisches Achsen-Item (entkoppelt von LoadedPlugin → testbar).
struct AxisItem {
    std::string id;
    std::vector<AxisKV> axes;
};

[[nodiscard]] inline AxisItem make_axis_item(std::string_view id, std::string_view axes_string) {
    return AxisItem{std::string{id}, parse_axes(axes_string)};
}

// Geordnete, eindeutige Achsen-Schlüssel über alle Items (Erst-Vorkommen-Reihenfolge).
[[nodiscard]] inline std::vector<std::string> collect_axis_keys(std::vector<AxisItem> const& items) {
    std::vector<std::string> keys;
    for (auto const& it : items) {
        for (auto const& kv : it.axes) {
            if (!kv.key.empty() &&
                std::find(keys.begin(), keys.end(), kv.key) == keys.end()) {
                keys.push_back(kv.key);
            }
        }
    }
    return keys;
}

// Hierarchischer Achsen-Baum.
struct AxisTreeNode {
    std::string axis_key;                  // gruppierende Achse dieser Ebene ("" = Wurzel)
    std::string axis_value;                // Wert dieser Ebene ("" = Wurzel)
    std::vector<AxisTreeNode> children;
    std::vector<std::size_t> item_indices; // nur an Blättern (depth == axis_order.size()) gefüllt
};

namespace detail {
inline void build_subtree(AxisTreeNode& node, std::vector<AxisItem> const& items,
                          std::vector<std::size_t> const& subset,
                          std::vector<std::string> const& axis_order, std::size_t depth) {
    if (depth >= axis_order.size()) {
        node.item_indices = subset;
        return;
    }
    std::string const& key = axis_order[depth];
    // std::map ⇒ deterministische, wertsortierte Gruppen-Reihenfolge.
    std::map<std::string, std::vector<std::size_t>> groups;
    for (auto idx : subset) {
        groups[axis_value(items[idx].axes, key).value_or("<none>")].push_back(idx);
    }
    for (auto const& [val, sub] : groups) {
        AxisTreeNode child;
        child.axis_key = key;
        child.axis_value = val;
        build_subtree(child, items, sub, axis_order, depth + 1);
        node.children.push_back(std::move(child));
    }
}
}  // namespace detail

// Baut den Achsen-Baum, der die Items entlang axis_order hierarchisch gruppiert.
[[nodiscard]] inline AxisTreeNode
build_axis_tree(std::vector<AxisItem> const& items, std::vector<std::string> const& axis_order) {
    AxisTreeNode root;
    std::vector<std::size_t> all(items.size());
    for (std::size_t i = 0; i < items.size(); ++i) all[i] = i;
    detail::build_subtree(root, items, all, axis_order, 0);
    return root;
}

// Anzahl Blatt-Items im (Teil-)Baum.
[[nodiscard]] inline std::size_t count_leaf_items(AxisTreeNode const& node) {
    if (node.children.empty()) return node.item_indices.size();
    std::size_t n = 0;
    for (auto const& c : node.children) n += count_leaf_items(c);
    return n;
}

// Item 4 — Achsen-Subtree-Gruppen: Items, die in ALLEN Achsen AUSSER `varying_axis` übereinstimmen.
// Innerhalb jeder zurückgegebenen Gruppe variiert NUR `varying_axis` → das ist der saubere
// „gleiche SIMD+Layout, vergleiche Allokator-Varianten"-Vergleich. Nur Gruppen mit ≥2 Items.
[[nodiscard]] inline std::vector<std::vector<std::size_t>>
subtree_groups_varying(std::vector<AxisItem> const& items,
                       std::vector<std::string> const& axis_keys,
                       std::string_view varying_axis) {
    std::map<std::string, std::vector<std::size_t>> buckets;
    for (std::size_t i = 0; i < items.size(); ++i) {
        std::string fixed;
        for (auto const& k : axis_keys) {
            if (k == varying_axis) continue;
            fixed += k + '=' + axis_value(items[i].axes, k).value_or("<none>") + ';';
        }
        buckets[fixed].push_back(i);
    }
    std::vector<std::vector<std::size_t>> out;
    for (auto& [_, v] : buckets) {
        if (v.size() >= 2) out.push_back(std::move(v));
    }
    return out;
}

}  // namespace comdare::messung_driver
