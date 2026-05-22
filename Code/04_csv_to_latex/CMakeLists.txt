# csv_to_latex — CSV + Algorithmus-Baustein-Beschreibungen → LaTeX
# Konsumiert binary_to_csv-Output + bausteine_descriptions JSON/XML.

add_library(comdare_csv_to_latex STATIC
    csv_to_latex.cpp
)
target_compile_features(comdare_csv_to_latex PUBLIC cxx_std_23)
target_include_directories(comdare_csv_to_latex PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
add_library(comdare::csv_to_latex ALIAS comdare_csv_to_latex)

add_executable(csv_to_latex_cli main_cli.cpp)
target_compile_features(csv_to_latex_cli PRIVATE cxx_std_23)
target_link_libraries(csv_to_latex_cli PRIVATE comdare::csv_to_latex)
set_target_properties(csv_to_latex_cli PROPERTIES OUTPUT_NAME "csv-to-latex")
