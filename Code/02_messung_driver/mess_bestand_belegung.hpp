#pragma once
// -----------------------------------------------------------------------------------------------
// mess_bestand_belegung.hpp -- LAG-P2-Rest (Kette D): die HOST-BELEGUNG des MESSWERT-Genus.
//
// SELBSTCHECK: diese Datei sichert zu, dass der Treiber ENTSCHEIDET, ob und mit welchem Dokument
// und welcher Maschinen-Identitaet das Messwert-Lager beschickt wird -- und dass er eine sich
// WIDERSPRECHENDE Belegung ABLEHNT statt sie zu binden. Sie sichert NICHT zu, dass das Dokument
// im Store entsteht (das sagt erst der flush des Iterators, "[bestandslog] messwert-lager=...").
//
// DER BEFUND, DEN SIE SCHLIESST. ce-seitig ist LAG-P2 vollstaendig: ProfileRunArgs::mess_bestand_*
// (profile_run_facade.hpp:134-138) -> profile_run_facade.cpp:768-770 -> ProfileRunEntryArgs
// (profile_run_entry.hpp:152-154) -> :708-710 -> LazyRunConfig::mess_bestand_*
// (cache_engine_builder_iterator.hpp:318-322), konsumiert bei :2056 (Gate), :2058 (load),
// :3026 (observe je gemessener Zelle), :2260 (flush). Die Kette ist LUECKENLOS -- nur der HOST
// belegte die Felder nicht. Gemessen in diesem Baum: "mess_bestand_" kommt in
// Code/02_messung_driver/main.cpp NULL Mal vor, waehrend das Schwester-Praefix "bestand_" 19 Mal
// vorkommt (Gegenprobe, damit der Nullbefund nicht bloss ein totes Suchmuster ist).
//
// -- WARUM DIE ENTSCHEIDUNG HIER STEHT UND NICHT IN main() --------------------------------------
// main() ist 1476 Zeilen und nicht ansprechbar; eine Zusicherung ueber "welcher Wert fuer welche
// Maschine" waere dort nur ueber einen Treiber-Lauf pruefbar. Als eigene reine Funktion ist sie
// mit Gegeneingaengen belegbar (Muster lane_vendor_guard.hpp, Scheibe 2a). main() ruft sie und
// bleibt der Ort des GATES -- die Aufteilung ist dieselbe wie dort: Entscheidung hier, Wirkung
// und Abbruch beim Aufrufer.
//
// -- DIE ZWEI ABLEHNUNGSGRUENDE, UND WARUM SIE ABLEHNUNGEN SIND ---------------------------------
// (1) maschine_leer. Der Messwert-Schluessel ist sha512 ueber [Binary-Fingerprint, HARDWARE].
//     Ist die Hardware-Identitaet leer, tragen ZWEI Maschinen fuer DIESELBE Zelle DENSELBEN
//     Schluessel -- prod2 wiese eine Messung von prod1 als eigene aus und uebersprnge sie. Das
//     ist woertlich der Fall, den messwert_key_source.hpp:51-53 "den Fall, den die Kampagne nicht
//     ueberleben darf" nennt. ce lehnt still ab (nullopt -> MesswertOutcome::no_key); hier wird
//     daraus eine BENANNTE Klasse, damit der Aufrufer laut abbrechen kann statt zwei Tage lang
//     leere Zeilen zu schreiben.
// (2) realm_kollision. Binaries- und Mess-Daten-Lager sind SEPARAT -- zwei Realms, getrennte
//     Lager (Owner-Abnahme 26.07., A-2; in ce als D-05 "JE REALM (eigener doc_key)" gefuehrt,
//     profile_run_facade.hpp:127-129: "zwei Dokumente in EINEM Store, nicht zwei Stores").
//     Zeigen beide doc_keys auf DASSELBE Dokument, verschmelzen die Realms still: der Mess-Flush
//     schreibt in das Binary-Dokument. Niemand prueft das heute. Das ist die zweite Gestalt
//     desselben Fehlers wie (1) -- zwei Anspruchsteller auf EINE Zelle.
//
// -- WAS BEWUSST NICHT PASSIERT ------------------------------------------------------------------
// mess_bestand_versions (G-E6, der Achsen-Versions-Tag) bleibt UNBELEGT. Im Host existiert keine
// Quelle dafuer: die Binary-Seite hat gar keinen versions-Parameter (LagerRunState::observe nimmt
// keinen), das Tag existiert nur im Messwert-Genus. Eine Umgebungsvariable dafuer zu erfinden
// hiesse, einen von Hand getippten Wert in JEDEN Messwert-Datensatz zu schreiben -- ein Feld zu
// fuellen, fuer das es keine Wahrheit gibt, ist kein Fortschritt. Leer = "nicht gemeldet" und
// v3-byte-gleiche Ausgabe (cache_engine_builder_iterator.hpp:320-322).
//
// DOKTRIN: header-only C++23 fuer die Entscheidung (keine ce-Includes, keine Env-Abfrage, kein
// I/O -- das Gate sitzt beim Aufrufer), ASCII-Kommentare. Der Schluessel-Binder darunter ist
// bewusst NUR deklariert: seine Definition braucht die schwere ce-Kette und liegt in der .cpp.
// -----------------------------------------------------------------------------------------------

#include <filesystem>
#include <functional>
#include <optional>
#include <string>
#include <string_view>

namespace comdare::diplomarbeit::messung_driver {

/// Ausgang der Host-Belegung. Genau EINE Klasse je Aufruf; `aktiv` ist die einzige, die bindet.
enum class MessBelegungKlasse {
    aktiv,           // alles stimmig -> binden
    aus,             // kein Mess-Doc-Key gesetzt -> Genus AUS. KEIN Fehler (inert-by-default).
    maschine_leer,   // ABLEHNUNG: ohne Hardware-Identitaet sind zwei Maschinen ununterscheidbar
    realm_kollision  // ABLEHNUNG: Mess- und Binary-Dokument sind dasselbe -> die Realms verschmelzen
};

[[nodiscard]] constexpr std::string_view to_string(MessBelegungKlasse k) noexcept {
    switch (k) {
        case MessBelegungKlasse::aktiv: return "aktiv";
        case MessBelegungKlasse::aus: return "aus";
        case MessBelegungKlasse::maschine_leer: return "maschine_leer";
        case MessBelegungKlasse::realm_kollision: return "realm_kollision";
    }
    return "unbekannt";
}

/// Das Ergebnis. `doc_key`/`maschine` sind NUR bei `aktiv` belegt -- eine abgelehnte Belegung
/// gibt keine Werte heraus, damit ein Aufrufer sie nicht versehentlich doch bindet.
struct MessBestandBelegung {
    MessBelegungKlasse klasse{MessBelegungKlasse::aus};
    std::string        doc_key{};
    std::string        maschine{};

    [[nodiscard]] bool aktiv() const noexcept { return klasse == MessBelegungKlasse::aktiv; }
    /// Ablehnung == der Aufrufer MUSS abbrechen. `aus` ist ausdruecklich KEINE Ablehnung.
    [[nodiscard]] bool abgelehnt() const noexcept {
        return klasse == MessBelegungKlasse::maschine_leer || klasse == MessBelegungKlasse::realm_kollision;
    }
};

namespace detail {
/// Randweisses abschneiden. Der Treiber liefert bereits env_trimmed-Werte; die Funktion trimmt
/// dennoch selbst, damit ihr Vertrag ohne Annahme ueber den Aufrufer gilt -- und damit der
/// Realm-Vergleich NACH dem Trimmen laeuft (" a.xml" und "a.xml" sind dasselbe Dokument).
[[nodiscard]] inline std::string_view trimme(std::string_view s) noexcept {
    auto const ws = [](char c) { return c == ' ' || c == '\t' || c == '\n' || c == '\r'; };
    while (!s.empty() && ws(s.front())) s.remove_prefix(1);
    while (!s.empty() && ws(s.back())) s.remove_suffix(1);
    return s;
}
} // namespace detail

/// DIE ENTSCHEIDUNG. Reine Funktion: gleiche Eingaben -> gleiche Klasse, kein I/O, keine Env.
///
/// Reihenfolge der Pruefungen ist Teil des Vertrags:
///   1. kein Mess-Doc-Key  -> `aus`   (nichts verlangt, also nichts abzulehnen)
///   2. Maschine leer      -> ABLEHNUNG maschine_leer
///   3. Mess == Binary     -> ABLEHNUNG realm_kollision
///   4. sonst              -> aktiv
[[nodiscard]] MessBestandBelegung belege_mess_bestand(std::string_view maschine,
                                                     std::string_view binary_doc_key,
                                                     std::string_view mess_doc_key_roh);

/// Der Schluessel-Binder des Messwert-Genus (ce bestandslog::make_messwert_key_fn).
///
/// WARUM NUR DEKLARIERT: messwert_key_source.hpp zieht ueber messwert_registrierung.hpp ->
/// bestandslog_document.hpp den ce-XML-DOM und ueber bestandslog_index.hpp die ABI-Kette
/// (anatomy_fingerprint.hpp -> das GENERIERTE overlay_source_hash_generated.hpp). Beides liegt
/// nicht im Include-Satz des messung_driver-Targets -- main.cpp:59-63 haelt genau diese Grenze
/// fuer den BestandTransport bereits fest und loest sie dort so, dass die schwere Bindung in
/// einer eigenen Uebersetzungseinheit sitzt. Hier dasselbe Muster: die .cpp traegt die Kette,
/// main.cpp sieht nur diese Signatur.
///
/// `maschine` leer => die zurueckgegebene Funktion liefert GRUNDSAETZLICH nullopt (ce-Regel
/// fehlerklasse=hardware_leer). Der Aufrufer soll diesen Fall vorher ueber belege_mess_bestand
/// abfangen -- die Doppelung ist Absicht, nicht Redundanz: sie haelt auch dann, wenn ein
/// kuenftiger zweiter Aufrufer das Gate vergisst.
[[nodiscard]] std::function<std::optional<std::string>(std::filesystem::path const&)>
make_mess_bestand_key_fn(std::string maschine);

} // namespace comdare::diplomarbeit::messung_driver
