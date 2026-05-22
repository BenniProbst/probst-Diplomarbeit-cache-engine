# REV 7.6 V21.3 — Sample-Mess-Daten-Generator
# Erzeugt V20-konforme Sample-CSV fuer Diagramm-Pipeline-Tests bevor
# reale HW-Mess-Daten verfuegbar sind (V21.2).

add_executable(sample_data_generator
    sample_data_generator.cpp
)

target_compile_features(sample_data_generator PRIVATE cxx_std_23)

if(MSVC)
    target_compile_options(sample_data_generator PRIVATE /W4 /WX-)
else()
    target_compile_options(sample_data_generator PRIVATE -Wall -Wextra)
endif()
