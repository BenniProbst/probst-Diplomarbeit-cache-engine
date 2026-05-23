# messung_driver — Master-Orchestrator der 3 Messreihen
# Ruft comdare::builder::ExperimentDriver (cache-engine library) auf.

add_executable(messung_driver main.cpp)
target_compile_features(messung_driver PRIVATE cxx_std_23)
target_include_directories(messung_driver PRIVATE
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include
    ${COMDARE_PRT_ART_DIR}/prt_art/include
)
# Library-Konsum: ExperimentDriver (cache-engine REV 7.6) + workload_generator
target_link_libraries(messung_driver PRIVATE
    comdare_builder_experiment_driver
    comdare::workload_generator
)
set_target_properties(messung_driver PROPERTIES
    OUTPUT_NAME "comdare-messung-driver"
)

# V32.JJ.2 (2026-05-18 spaet) - V32 Orchestrator-Header verfuegbar machen
option(COMDARE_V32_ENABLE "Enable V32 Orchestrator (parallele EE-Submission via Command-Pattern)" OFF)
if(COMDARE_V32_ENABLE)
    target_compile_definitions(messung_driver PRIVATE COMDARE_V32_ENABLE=1)
    target_include_directories(messung_driver PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}  # fuer v32_orchestrator.hpp
    )
    message(STATUS "[messung_driver] V32 Orchestrator AKTIVIERT (parallele EE-A + EE-B)")
else()
    message(STATUS "[messung_driver] V32 Orchestrator DEAKTIVIERT (V31.F Default)")
endif()

# V36.D (2026-05-23) - Runtime-Check fuer Pre-Build-Permutationen
# Pfade zur generierten Manifests via compile-time defines durchreichen.
target_compile_definitions(messung_driver PRIVATE
    "COMDARE_PERMUTATIONS_MANIFEST_CE=\"${CMAKE_BINARY_DIR}/generated/permutations_manifest.txt\""
    "COMDARE_PERMUTATIONS_MANIFEST_PA=\"${CMAKE_BINARY_DIR}/generated/prt_art_permutations_manifest.txt\"")
