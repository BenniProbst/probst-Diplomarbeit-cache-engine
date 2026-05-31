# V41.E10.3-E10.5 — STATIC/SHARED-Linkage-Achse PRO DIPLOMARBEIT-UNTERMODUL.
#
# Ergänzt die cache-engine-seitige pro-Projekt-Achse (E10.1/E10.2, comdare_add_library.cmake) um die
# vom User explizit geforderte per-Untermodul-Granularität ("je Projekt einzeln UND in der Diplomarbeit
# je Projekt-Untermodul"). Steuert den Linkage-Typ der Pipeline-Submodul-Libraries (M01..M06) einzeln.
#
# Steuerung (zwei Ebenen):
#   • Globaler Default:     COMDARE_DA_BUILD_SHARED_LIBS         (OFF = STATIC ⇒ keine Regression)
#   • Pro-Untermodul:       COMDARE_DA_<Mxx>_BUILD_SHARED         (default = globaler Wert)
#     Untermodul-Schlüssel: M01 sample_data_generator · M02 messung_driver · M03 binary_to_csv ·
#                           M04 csv_to_latex · M05 diagram_generator · M06 latex_to_pdf
#
# Verwendung:
#   comdare_da_add_library(<target> MODULE <Mxx> SOURCES <src...>)
#
# Hinweis: Exe-only-Untermodule (M01/M02) haben keine Library → die Option existiert dort als
# dokumentierter No-Op (greift, sobald ein Untermodul eine Library hinzufügt). Permutations-DLLs
# bleiben aussen SHARED / innen STATIC (unberührt von dieser Achse).

if(NOT DEFINED COMDARE_DA_BUILD_SHARED_LIBS)
    option(COMDARE_DA_BUILD_SHARED_LIBS
        "Globaler Default-Linkage der Diplomarbeit-Untermodul-Libs als SHARED (OFF = STATIC)" OFF)
endif()

function(comdare_da_add_library target)
    set(_options)
    set(_one_value MODULE)
    set(_multi_value SOURCES)
    cmake_parse_arguments(ARG "${_options}" "${_one_value}" "${_multi_value}" ${ARGN})

    if(NOT ARG_MODULE)
        message(FATAL_ERROR "comdare_da_add_library(${target}): MODULE <Mxx> erforderlich.")
    endif()
    if(NOT ARG_SOURCES)
        message(FATAL_ERROR "comdare_da_add_library(${target}): SOURCES erforderlich.")
    endif()

    # Pro-Untermodul-Option (default = globaler COMDARE_DA_BUILD_SHARED_LIBS-Wert; user-überschreibbar).
    set(_mod_var "COMDARE_DA_${ARG_MODULE}_BUILD_SHARED")
    if(NOT DEFINED ${_mod_var})
        set(${_mod_var} "${COMDARE_DA_BUILD_SHARED_LIBS}" CACHE BOOL
            "Linkage von Diplomarbeit-Untermodul ${ARG_MODULE} als SHARED (default folgt COMDARE_DA_BUILD_SHARED_LIBS)")
    endif()

    if(${${_mod_var}})
        set(_type SHARED)
    else()
        set(_type STATIC)
    endif()

    add_library(${target} ${_type} ${ARG_SOURCES})

    if(_type STREQUAL "SHARED")
        set_target_properties(${target} PROPERTIES
            WINDOWS_EXPORT_ALL_SYMBOLS ON
            POSITION_INDEPENDENT_CODE  ON)
    endif()

    message(STATUS "comdare_da_add_library: ${target} (Untermodul ${ARG_MODULE}) => ${_type}")
endfunction()
