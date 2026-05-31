// V41.G.1 — Unit-Test des hierarchischen Achsen-Baums (axis_tree.hpp).

#include "axis_tree.hpp"

#include <gtest/gtest.h>

#include <string>
#include <vector>

namespace md = ::comdare::messung_driver;

// Parser: codegen-Format "simd=avx2,layout=soa,alloc=std (real=mimalloc)".
TEST(G1_AxisTree, ParsesCodegenAxesString) {
    auto kv = md::parse_axes("simd=avx2,layout=soa,alloc=std (real=mimalloc)");
    ASSERT_EQ(kv.size(), 3u);
    EXPECT_EQ(kv[0].key, "simd");   EXPECT_EQ(kv[0].value, "avx2");
    EXPECT_EQ(kv[1].key, "layout"); EXPECT_EQ(kv[1].value, "soa");
    EXPECT_EQ(kv[2].key, "alloc");  EXPECT_EQ(kv[2].value, "std (real=mimalloc)");
    EXPECT_EQ(md::axis_value(kv, "layout").value_or("?"), "soa");
    EXPECT_FALSE(md::axis_value(kv, "nonexistent").has_value());
}

// Achsen-Schlüssel werden geordnet + eindeutig gesammelt.
TEST(G1_AxisTree, CollectsOrderedUniqueKeys) {
    std::vector<md::AxisItem> items{
        md::make_axis_item("a", "simd=avx2,layout=soa,alloc=std"),
        md::make_axis_item("b", "simd=sse,layout=aos,alloc=pool"),
    };
    auto keys = md::collect_axis_keys(items);
    ASSERT_EQ(keys.size(), 3u);
    EXPECT_EQ(keys[0], "simd");
    EXPECT_EQ(keys[1], "layout");
    EXPECT_EQ(keys[2], "alloc");
}

// Baum gruppiert hierarchisch entlang der Achsen-Reihenfolge; jede Ebene = eine Achse.
TEST(G1_AxisTree, BuildsHierarchicalTree) {
    std::vector<md::AxisItem> items{
        md::make_axis_item("p0", "simd=avx2,layout=soa,alloc=std"),
        md::make_axis_item("p1", "simd=avx2,layout=soa,alloc=pool"),
        md::make_axis_item("p2", "simd=avx2,layout=aos,alloc=std"),
        md::make_axis_item("p3", "simd=sse,layout=soa,alloc=std"),
    };
    auto keys = md::collect_axis_keys(items);
    auto root = md::build_axis_tree(items, keys);

    // Ebene 1 (simd): zwei Gruppen avx2 / sse.
    ASSERT_EQ(root.children.size(), 2u);
    EXPECT_EQ(root.children[0].axis_key, "simd");
    EXPECT_EQ(root.children[0].axis_value, "avx2");  // map-sortiert: avx2 < sse
    EXPECT_EQ(root.children[1].axis_value, "sse");
    // avx2 hat 2 layout-Untergruppen (soa, aos); soa hat 2 alloc-Blätter.
    auto const& avx2 = root.children[0];
    ASSERT_EQ(avx2.children.size(), 2u);     // aos, soa
    EXPECT_EQ(avx2.children[0].axis_value, "aos");
    EXPECT_EQ(avx2.children[1].axis_value, "soa");
    EXPECT_EQ(md::count_leaf_items(avx2.children[1]), 2u);  // soa: std + pool
    // Alle 4 Items als Blätter erreichbar.
    EXPECT_EQ(md::count_leaf_items(root), 4u);
}

// Item 4 — Subtree-Gruppen: variiere NUR alloc, fixiere simd+layout.
TEST(G1_AxisTree, SubtreeGroupsVaryingAllocator) {
    std::vector<md::AxisItem> items{
        md::make_axis_item("p0", "simd=avx2,layout=soa,alloc=std"),
        md::make_axis_item("p1", "simd=avx2,layout=soa,alloc=pool"),  // gleiche simd+layout wie p0
        md::make_axis_item("p2", "simd=avx2,layout=aos,alloc=std"),   // andere layout → eigene Gruppe
        md::make_axis_item("p3", "simd=sse,layout=soa,alloc=std"),    // andere simd → eigene Gruppe
    };
    auto keys = md::collect_axis_keys(items);
    auto groups = md::subtree_groups_varying(items, keys, "alloc");
    // Nur die (avx2,soa)-Gruppe hat ≥2 Items (p0,p1); die anderen sind Singletons → ausgefiltert.
    ASSERT_EQ(groups.size(), 1u);
    EXPECT_EQ(groups[0].size(), 2u);
    std::vector<std::string> ids{items[groups[0][0]].id, items[groups[0][1]].id};
    EXPECT_TRUE((ids == std::vector<std::string>{"p0", "p1"}) ||
                (ids == std::vector<std::string>{"p1", "p0"}));
}
