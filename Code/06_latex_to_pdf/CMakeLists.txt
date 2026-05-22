# latex_to_pdf — Driver-Skript (CMake-only, kein C++)
# Liest LaTeX-Anhang (von csv_to_latex + diagram_generator) → pdflatex 2x + bibtex.
#
# Aufruf direkt via:
#   cmake -DCOMDARE_THESIS_SOURCE=<dir> -DCOMDARE_THESIS_OUTPUT=<dir> \
#         -P latex_toolchain.cmake

# Kopiere die Toolchain-CMake aus cache-engine/tools/latex_toolchain/
# in den Build-Output, damit sie aus Diplomarbeit/Code/build/ erreichbar ist.
configure_file(
    "${COMDARE_CACHE_ENGINE_DIR}/tools/latex_toolchain/latex_toolchain.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/latex_toolchain.cmake"
    COPYONLY)

# Standard-Driver-Skript (Frontend)
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/build_thesis.sh"
    "${CMAKE_CURRENT_BINARY_DIR}/build_thesis.sh"
    COPYONLY)
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/build_thesis.bat"
    "${CMAKE_CURRENT_BINARY_DIR}/build_thesis.bat"
    COPYONLY)

message(STATUS "latex_to_pdf: Toolchain bereit unter ${CMAKE_CURRENT_BINARY_DIR}")
