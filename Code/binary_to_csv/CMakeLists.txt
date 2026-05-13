# binary_to_csv — Deserialisiert measurement_record_v1 binary → CSV
# Konsumiert cache-engine ABI (module_abi_v1.hpp).

add_library(comdare_binary_to_csv STATIC
    binary_to_csv.cpp
)
target_compile_features(comdare_binary_to_csv PUBLIC cxx_std_23)
target_include_directories(comdare_binary_to_csv PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${COMDARE_CACHE_ENGINE_DIR}/cache_engine/include
)
add_library(comdare::binary_to_csv ALIAS comdare_binary_to_csv)

add_executable(binary_to_csv_cli main_cli.cpp)
target_compile_features(binary_to_csv_cli PRIVATE cxx_std_23)
target_link_libraries(binary_to_csv_cli PRIVATE comdare::binary_to_csv)
set_target_properties(binary_to_csv_cli PROPERTIES
    OUTPUT_NAME "binary-to-csv"
)
