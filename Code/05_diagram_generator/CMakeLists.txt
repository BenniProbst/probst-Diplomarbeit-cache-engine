# diagram_generator — C++ Bildgenerator (TikZ-Output, A4-aware)
# Liest CSV → schreibt TikZ-Code → wird in LaTeX-Manuskript eingebunden.

add_library(comdare_diagram_generator STATIC
    diagram_generator.cpp
)
target_compile_features(comdare_diagram_generator PUBLIC cxx_std_23)
target_include_directories(comdare_diagram_generator PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
add_library(comdare::diagram_generator ALIAS comdare_diagram_generator)

add_executable(diagram_generator_cli main_cli.cpp)
target_compile_features(diagram_generator_cli PRIVATE cxx_std_23)
target_link_libraries(diagram_generator_cli PRIVATE comdare::diagram_generator)
set_target_properties(diagram_generator_cli PROPERTIES
    OUTPUT_NAME "diagram-generator"
)
