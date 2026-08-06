// A1-Fixup Fingerprint-Naht-Sonde (SCRATCH, NICHT im Repo): druckt die allocator-Zeilen der
// {axis,variant->algo_version}-Tabelle, die daraus gebaute Organ-Stempel-Zeile einer realen
// golden-320-binary_id und den daraus abgeleiteten 128-hex-Anatomie-Fingerprint.
// Vor/nach dem Versions-Bump zweimal gebaut == zwei Binaries mit (erwartet) verschiedenem Fingerprint.

#include "lazy_adhoc_source_gen.hpp"

#include <builder/experiment_tree/axis_variant_version_table.hpp>

#include <cstdio>
#include <string>
#include <vector>

namespace ex  = ::comdare::cache_engine::builder::experiment;
namespace tlz = ::comdare::cache_engine::thesis_lazy;

int main() {
    auto const version_table = ex::build_axis_variant_version_table();
    for (auto const& e : version_table)
        if (e.axis == "allocator") std::printf("TABLE allocator=%s@%s\n", e.variant.c_str(), e.version.c_str());

    // Zeile 1 (nach den 6 Kommentarzeilen) aus tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt
    std::string const id =
        "search_algo=k_ary/cache_traversal=linear_fanout/mapping=direct_placement/"
        "path_compression=path_compression_none/node_type=node4/"
        "memory_layout=memory_layout_cache_line_aligned/allocator=std_malloc/prefetch=prefetch_none/"
        "concurrency=concurrency_none/serialization=serialization_raw_binary/value_handle=value_handle_inline/"
        "index_organization=index_org_heap/io_dispatch=io_in_memory_only/migration_policy=migration_none/"
        "filter=filter_bloom/queuing_q1=no_buffer/queuing_q2=eager_flush/"
        "persistence_target=persistence_memory_only";

    std::string const organ = ex::compose_organ_stamp_line(ex::ceb_parse_path(id), version_table);
    std::printf("ORGAN %s\n", organ.c_str());

    std::string const algos = ex::compose_algo_signature(ex::ceb_parse_path(id), version_table);
    std::printf("ALGOSIG %s\n", algos.c_str());

    auto const        tables = tlz::lazy_slot_type_tables();
    std::string const fp     = tlz::lazy_adhoc_fingerprint_for(tables, id, version_table);
    std::printf("FINGERPRINT %s\n", fp.c_str());
    return 0;
}
