// -----------------------------------------------------------------------------------------------
// mess_bestand_belegung.cpp -- die Umsetzung der Host-Belegung (LAG-P2-Rest, Kette D).
//
// Diese Uebersetzungseinheit ist die EINZIGE in super, die den ce-Bestandslog-Schluesselweg
// inkludiert. Warum sie getrennt vom Treiber steht, steht im Kopf des Headers und ausfuehrlich in
// CMakeLists.txt bei comdare_mess_bestand_belegung -- kurz: messwert_key_source.hpp zieht den
// ce-XML-DOM und die ABI-/Codegen-Kette nach, die im Include-Satz des messung_driver-Targets
// bewusst nicht liegen.
//
// ASCII-only.
// -----------------------------------------------------------------------------------------------

#include "mess_bestand_belegung.hpp"

// Die EINE Ableitung des Messwert-Schluessels. NICHT abschreiben, sondern rufen: eine zweite
// Schluessel-Bildung in super waere genau die Drift, die messwert_key_source.hpp:20-24 fuer die
// Sidecar-Lektuere bereits ausschliesst -- und sie faellt nicht auf, sie dedupliziert nur falsch.
#include <builder/bestandslog/messwert_key_source.hpp>

#include <utility>

namespace comdare::diplomarbeit::messung_driver {

namespace bl = ::comdare::cache_engine::builder::bestandslog;

MessBestandBelegung belege_mess_bestand(std::string_view maschine, std::string_view binary_doc_key,
                                        std::string_view mess_doc_key_roh) {
    auto const mess   = detail::trimme(mess_doc_key_roh);
    auto const binary = detail::trimme(binary_doc_key);
    auto const masch  = detail::trimme(maschine);

    // (1) Nichts verlangt -> nichts abzulehnen. Diese Reihenfolge ist Absicht: sie haelt den
    //     Vor-Zustand byte-neutral, in dem KEINE der neuen Variablen gesetzt ist -- dort darf
    //     weder eine Ablehnung noch eine Zeile fallen.
    if (mess.empty()) return MessBestandBelegung{MessBelegungKlasse::aus, {}, {}};

    // (2) Ohne Hardware-Identitaet waeren zwei Maschinen fuer dieselbe Zelle ununterscheidbar.
    if (masch.empty()) return MessBestandBelegung{MessBelegungKlasse::maschine_leer, {}, {}};

    // (3) Ein Dokument kann nicht beide Realms tragen. Der Vergleich laeuft NACH dem Trimmen --
    //     sonst schluepft die Kollision durch, sobald eine CI-Variable ein Leerzeichen mitbringt.
    if (mess == binary) return MessBestandBelegung{MessBelegungKlasse::realm_kollision, {}, {}};

    return MessBestandBelegung{MessBelegungKlasse::aktiv, std::string{mess}, std::string{masch}};
}

std::function<std::optional<std::string>(std::filesystem::path const&)> make_mess_bestand_key_fn(std::string maschine) {
    // Der Dateiname der Tier-Binary bleibt der ce-Default (kTierBinaryDateiname == "perm.dll") --
    // ihn hier zu wiederholen waere eine siebte Kopie desselben Literals (messwert_key_source.hpp
    // :74-80 fuehrt die sechs bestehenden auf und begruendet den Default-Parameter genau damit).
    return bl::make_messwert_key_fn(std::move(maschine));
}

} // namespace comdare::diplomarbeit::messung_driver
