// mutations_lauf.cpp -- Umsetzung (Begruendung im Kopf von mutations_lauf.hpp).
//
// DER KATALOG STEHT IN DIESER DATEI, nicht in einer Datendatei daneben. Grund: die
// Anker sind Quelltext-Ausschnitte, und ein Quelltext-Ausschnitt in einer .txt-Datei
// haette keinen Uebersetzer ueber sich. Hier faengt schon der Bau eine kaputte
// Zeichenkette ab, und der Google Test prueft zusaetzlich gegen die ECHTE
// Produktionsdatei, ob der Anker noch GENAU so oft dort steht.
//
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/mutations_lauf.hpp"

#include <cstdio>
#include <fstream>
#include <sstream>

#include "comdare/ci_wachen/prozess.hpp"

namespace comdare::ci_wachen {
namespace {

// ---- DIE FUENF MUTANTEN ------------------------------------------------------------
// Jeder einzelne hebt EINE benannte Zusicherung auf. Die Klasse ist die des Designplans
// V7 Abschnitt 2; die Vorhersage nennt die Tests, die nach Lesen des Bestandes reissen
// MUESSTEN. Vorhersage und Messung sind getrennt: ein Mutant, der ueberlebt, ist ein
// BEFUND ueber die Suite -- er wird nicht nachtraeglich zurechtgebogen.
constexpr Mutant KATALOG[] = {
    // M1 -- die Fail-Closed-Kante der XML-Wache. "Werkzeug fehlt" wird zu "alles gut".
    {"M1-xml-fail-open",
     "Code/ci_wachen/src/xml_wellformed.cpp",
     Testklasse::KeineNegativprobe,
     "Ein fehlender XML-Parser ist ABBRUCH, niemals GRUEN (fail-closed).",
     R"MUT(                ergebnis.status         = WacheStatus::Abbruch;
                ergebnis.abbruch        = XmlAbbruchGrund::ParserFehlt;)MUT",
     R"MUT(                ergebnis.status         = WacheStatus::Gruen;
                ergebnis.abbruch        = XmlAbbruchGrund::ParserFehlt;)MUT",
     1,
     {"XmlWacheNaht.F06_ParserFehltIstAbbruchNiemalsGruen", "XmlWacheE2E.LeererBestandLiefertExit2NichtExit0"}},

    // M2 -- der eingefrorene Defekt wird UNSICHTBAR. Das Urteil bleibt gleich; nur die
    // Zahl im Protokoll verschwindet. Genau die Klasse K5: der Test haelt das kranke
    // Verhalten als Soll fest -- die Frage ist, ob er die ZAHL ueberhaupt fordert.
    {"M2-xml-nicht-gelesen-zaehler",
     "Code/ci_wachen/src/xml_wellformed.cpp",
     Testklasse::TestZementiertDefekt,
     "Eine im Index gelistete, im Arbeitsbaum fehlende Datei wird gezaehlt (nicht_gelesen).",
     R"MUT(            ++ergebnis.nicht_gelesen;
)MUT",
     "",
     1,
     {"XmlWache/XmlWacheFall.Fall/F09_eingefroren_index_aber_nicht_im_arbeitsbaum",
      "XmlWacheNaht.NennerKommtAusDerAufzaehlungNichtAusDenGelesenenDateien"}},

    // M3 -- die SCHWESTERSTELLE (T-6). Nur noch EINER der beiden Gitlink-Pfade wird auf
    // Anwesenheit geprueft. Der lebende Pfad bleibt bewacht, der tote nicht.
    {"M3-parity-schwesterstelle",
     "Code/ci_wachen/src/gitlink_parity.cpp",
     Testklasse::KeineNegativprobe,
     "BEIDE Gitlink-Pfade werden auf Anwesenheit geprueft, nicht nur der lebende.",
     R"MUT(    if (!b.ist_gitlink()) ergebnis.fehlende_pfade.emplace_back(PFAD_TOT);
)MUT",
     "",
     1,
     {"ParityWache/ParityFallTest.Fall/F05_nur_der_tote_fehlt_quelle_head",
      "ParityWache/ParityFallTest.Fall/F06_BEIDE_fehlen_der_schaerfste_fall_quelle_head"}},

    // M4 -- der Nenner-Riegel des WIDE-Aggregats faellt ersatzlos. Die Identitaet
    // quellen == mit_daten + ohne_daten + nicht_lesbar wird nicht mehr geprueft.
    {"M4-wide-nenner-riegel",
     "Code/ci_wachen/src/wide_aggregat.cpp",
     Testklasse::KeineNegativprobe,
     "Verletzt die Quellen-Identitaet, ist das ABBRUCH -- nicht eine stille Zahl.",
     R"MUT(    if (!ergebnis.nenner_haelt()) {
        ergebnis.status         = WacheStatus::Abbruch;
        ergebnis.abbruch        = AggregatAbbruchGrund::NennerVerletzt;
        ergebnis.abbruch_detail = "quellen != mit_daten + ohne_daten + nicht_lesbar";
        return ergebnis;
    }
)MUT",
     "",
     1,
     {"WideFall.DerNennerIstEineIdentitaetKeineSchaetzung", ""}},

    // M5 -- die Block-Ende-Erkennung des CI-YAML-Scanners verliert den Tabulator. Ein
    // tabulator-eingerueckter Job-Block endete danach zu frueh; alles danach faellt aus
    // der Zaehlung. Klassisch K1: der Zweig hat keinen Gegeneingang, solange keine
    // Fixture je einen Tabulator traegt.
    {"M5-yml-tabulator",
     "Code/ci_wachen/src/ci_yml_scanner.cpp",
     Testklasse::KeineNegativprobe,
     "Spalte 0 heisst: weder Leerzeichen NOCH Tabulator am Zeilenanfang.",
     R"MUT(    return !zeile.empty() && zeile.front() != ' ' && zeile.front() != '\t';)MUT",
     R"MUT(    return !zeile.empty() && zeile.front() != ' ';)MUT",
     1,
     {"CiYmlScanner.BlockEndetAnSpalteNullEinschliesslichKommentaren",
      "CiYmlScanner.KommentarerkennungAchtetAufEinrueckung"}},
};

static_assert(sizeof(KATALOG) / sizeof(KATALOG[0]) == KATALOG_SOLL,
              "Der Katalog ist gewachsen oder geschrumpft -- KATALOG_SOLL nachziehen (T-3: EIN Nenner).");

std::vector<std::string> in_zeilen(std::string_view text) {
    std::vector<std::string> zeilen;
    std::string              lauf;
    for (const char zeichen : text) {
        if (zeichen == '\n') {
            zeilen.push_back(lauf);
            lauf.clear();
        } else if (zeichen != '\r') {
            lauf.push_back(zeichen);
        }
    }
    if (!lauf.empty()) zeilen.push_back(lauf);
    return zeilen;
}

// Aus "\t112 - Name.Fall (Failed)" wird "Name.Fall". Liefert leer, wenn die Zeile die
// Form NICHT hat -- der Aufrufer bricht die Liste dann ab, statt weiterzuraten.
std::string test_name_aus_fehlerzeile(const std::string& zeile) {
    std::size_t i = 0;
    while (i < zeile.size() && (zeile[i] == ' ' || zeile[i] == '\t')) ++i;
    std::size_t ziffern = 0;
    while (i + ziffern < zeile.size() && zeile[i + ziffern] >= '0' && zeile[i + ziffern] <= '9') ++ziffern;
    if (ziffern == 0) return {};
    i += ziffern;
    if (zeile.compare(i, 3, " - ") != 0) return {};
    i += 3;
    const std::size_t klammer = zeile.rfind(" (");
    if (klammer == std::string::npos || klammer <= i) return {};
    return zeile.substr(i, klammer - i);
}

} // namespace

std::span<const Mutant> katalog() { return {KATALOG, sizeof(KATALOG) / sizeof(KATALOG[0])}; }

std::string ausgang_text(MutantAusgang ausgang) {
    switch (ausgang) {
        case MutantAusgang::VomBauGetoetet: return "VOM-BAU-GETOETET";
        case MutantAusgang::VomTestGetoetet: return "VOM-TEST-GETOETET";
        case MutantAusgang::Ueberlebend: return "UEBERLEBEND";
        case MutantAusgang::HarnessAbbruch: return "HARNESS-ABBRUCH";
    }
    return "UNBEKANNT";
}

std::string klasse_text(Testklasse klasse) {
    switch (klasse) {
        case Testklasse::KeineNegativprobe: return "K1 keine-negativprobe";
        case Testklasse::TestZementiertDefekt: return "K5 test-zementiert-defekt";
    }
    return "UNBEKANNT";
}

std::string lauf_abbruch_text(LaufAbbruchGrund grund) {
    switch (grund) {
        case LaufAbbruchGrund::BaumSchmutzigVorher: return "BaumSchmutzigVorher";
        case LaufAbbruchGrund::GrundlaufBauRot: return "GrundlaufBauRot";
        case LaufAbbruchGrund::GrundlaufSuiteUnlesbar: return "GrundlaufSuiteUnlesbar";
        case LaufAbbruchGrund::GrundlaufSuiteRot: return "GrundlaufSuiteRot";
        case LaufAbbruchGrund::GrundlaufLeererNenner: return "GrundlaufLeererNenner";
        case LaufAbbruchGrund::RuecknahmeNichtByteGleich: return "RuecknahmeNichtByteGleich";
        case LaufAbbruchGrund::BaumSchmutzigNachher: return "BaumSchmutzigNachher";
    }
    return "UNBEKANNT";
}

std::size_t zaehle_vorkommen(std::string_view heuhaufen, std::string_view nadel) {
    if (nadel.empty()) return 0;
    std::size_t treffer = 0;
    std::size_t i       = heuhaufen.find(nadel);
    while (i != std::string_view::npos) {
        ++treffer;
        i = heuhaufen.find(nadel, i + nadel.size());
    }
    return treffer;
}

ErsetzErgebnis ersetze_genau(std::string_view inhalt, std::string_view suchen, std::string_view ersetzen,
                             std::size_t erwartete_treffer) {
    ErsetzErgebnis ergebnis;
    if (suchen.empty()) {
        ergebnis.diagnose = "leerer Anker -- ein Mutant ohne Stelle ist kein Mutant";
        return ergebnis;
    }
    if (erwartete_treffer == 0) {
        ergebnis.diagnose = "erwartete_treffer == 0 -- das waere eine Mutation, die nichts anfasst";
        return ergebnis;
    }
    if (suchen == ersetzen) {
        ergebnis.diagnose = "suchen == ersetzen -- der Mutant aendert nichts und ueberlebt trivial";
        return ergebnis;
    }
    ergebnis.gefunden = zaehle_vorkommen(inhalt, suchen);
    if (ergebnis.gefunden != erwartete_treffer) {
        ergebnis.diagnose = "Anker steht " + std::to_string(ergebnis.gefunden) + " mal in der Datei, erwartet " +
                            std::to_string(erwartete_treffer) +
                            " -- FAIL-CLOSED: es wird NICHT mutiert (sonst liefe der Mutant ins Leere)";
        return ergebnis;
    }
    std::string neu;
    neu.reserve(inhalt.size());
    std::size_t gelesen = 0;
    while (true) {
        const std::size_t i = inhalt.find(suchen, gelesen);
        if (i == std::string_view::npos) break;
        neu.append(inhalt, gelesen, i - gelesen);
        neu.append(ersetzen);
        gelesen = i + suchen.size();
    }
    neu.append(inhalt, gelesen, inhalt.size() - gelesen);
    ergebnis.inhalt = std::move(neu);
    ergebnis.ok     = true;
    return ergebnis;
}

CtestBefund lies_ctest_befund(std::string_view ausgabe) {
    CtestBefund                    befund;
    const std::vector<std::string> zeilen = in_zeilen(ausgabe);

    for (const std::string& zeile : zeilen) {
        int prozent  = 0;
        int gefallen = 0;
        int gesamt   = 0;
        // Die ZUSAMMENFASSUNGSZEILE ist die Aussage, nicht die Anwesenheit des Wortes
        // "failed". ctest schreibt sie GENAU einmal; wir nehmen die letzte.
        if (std::sscanf(zeile.c_str(), "%d%% tests passed, %d tests failed out of %d", &prozent, &gefallen, &gesamt) ==
            3) {
            befund.zusammenfassung_gelesen = true;
            befund.gefallen                = gefallen;
            befund.gesamt                  = gesamt;
        }
    }

    for (std::size_t i = 0; i < zeilen.size(); ++i) {
        if (zeilen[i] != "The following tests FAILED:") continue;
        for (std::size_t j = i + 1; j < zeilen.size(); ++j) {
            const std::string name = test_name_aus_fehlerzeile(zeilen[j]);
            if (name.empty()) break;
            befund.rote_tests.push_back(name);
        }
        break;
    }
    return befund;
}

std::optional<std::string> lies_datei_ganz(const std::filesystem::path& datei) {
    std::error_code fehler;
    if (!std::filesystem::is_regular_file(datei, fehler) || fehler) return std::nullopt;
    std::ifstream strom(datei, std::ios::binary);
    if (!strom) return std::nullopt;
    std::ostringstream puffer;
    puffer << strom.rdbuf();
    if (strom.bad()) return std::nullopt;
    return puffer.str();
}

bool schreibe_datei_ganz(const std::filesystem::path& datei, std::string_view inhalt) {
    std::ofstream strom(datei, std::ios::binary | std::ios::trunc);
    if (!strom) return false;
    strom.write(inhalt.data(), static_cast<std::streamsize>(inhalt.size()));
    strom.flush();
    if (!strom) return false;
    strom.close();
    return !strom.fail();
}

// ---- Die echte Naht -----------------------------------------------------------------
EchteLaufNaht::EchteLaufNaht(std::filesystem::path repo, std::filesystem::path bauverzeichnis, std::string ctest_label,
                             int bau_jobs)
    : repo_(std::move(repo)), bau_(std::move(bauverzeichnis)), label_(std::move(ctest_label)), jobs_(bau_jobs) {}

bool EchteLaufNaht::baue() {
    ProzessAuftrag auftrag;
    auftrag.argv = {
        "cmake", "--build", bau_.string(), "-j", std::to_string(jobs_), "--target", "comdare_da_unit_tests"};
    const ProzessAusgang aus = fuehre_aus(auftrag);
    letzte_bau_ausgabe_      = aus.ausgabe + aus.fehler;
    // Nur ein echter exit(0) ist ein gruener Bau. Ein fehlendes cmake liefert KEINEN
    // Exit-Code und kann deshalb nie mit 0 verwechselt werden (prozess.hpp).
    return exit_code(aus).value_or(-1) == 0;
}

std::string EchteLaufNaht::fahre_suite() {
    ProzessAuftrag auftrag;
    auftrag.argv             = {"ctest", "--test-dir", bau_.string(), "-L", label_, "-j", "4", "--output-on-failure"};
    const ProzessAusgang aus = fuehre_aus(auftrag);
    return aus.ausgabe + aus.fehler;
}

std::string EchteLaufNaht::arbeitsbaum_status() {
    const ProzessAusgang aus = fuehre_git_aus(repo_, {"status", "--porcelain"});
    if (exit_code(aus).value_or(-1) != 0) {
        // FAIL-CLOSED: antwortet git nicht, gilt der Baum als NICHT belegt sauber.
        return "git-status nicht beantwortbar: " + aus.beschreibung();
    }
    return aus.ausgabe;
}

std::string EchteLaufNaht::bezeichnung() const {
    return "EchteLaufNaht(bau=" + bau_.string() + ", label=" + label_ + ")";
}

// ---- Der Lauf -------------------------------------------------------------------------
MutationsLaufErgebnis fahre_mutationslauf(const std::filesystem::path& repo, LaufNaht& naht,
                                          std::span<const Mutant> mutanten) {
    MutationsLaufErgebnis ergebnis;
    ergebnis.katalog_gesamt = mutanten.size();

    // (0) OHNE SAUBEREN BAUM IST "byte-gleich danach" NICHT BELEGBAR. Der Nachweis der
    //     Ruecknahme haengt an genau dieser Vorbedingung -- deshalb steht sie zuerst.
    const std::string status_vorher = naht.arbeitsbaum_status();
    if (!status_vorher.empty()) {
        ergebnis.abbruch        = LaufAbbruchGrund::BaumSchmutzigVorher;
        ergebnis.abbruch_detail = status_vorher;
        return ergebnis;
    }

    // (1) DER GEGENKOEDER (K13): der UNMANIPULIERTE Lauf muss gruen sein. Ist er es
    //     nicht, ist kein einziger Mutant zurechenbar.
    if (!naht.baue()) {
        ergebnis.abbruch        = LaufAbbruchGrund::GrundlaufBauRot;
        ergebnis.abbruch_detail = "der Bau ist schon OHNE Mutation rot";
        return ergebnis;
    }
    const CtestBefund grundlauf = lies_ctest_befund(naht.fahre_suite());
    if (!grundlauf.zusammenfassung_gelesen) {
        ergebnis.abbruch        = LaufAbbruchGrund::GrundlaufSuiteUnlesbar;
        ergebnis.abbruch_detail = "ctest hat keine Zusammenfassungszeile geliefert";
        return ergebnis;
    }
    if (grundlauf.gesamt <= 0) {
        ergebnis.abbruch        = LaufAbbruchGrund::GrundlaufLeererNenner;
        ergebnis.abbruch_detail = "0 Tests ausgewaehlt -- ein leerer Nenner ist kein bestandener Lauf";
        return ergebnis;
    }
    if (grundlauf.gefallen != 0) {
        ergebnis.abbruch        = LaufAbbruchGrund::GrundlaufSuiteRot;
        ergebnis.abbruch_detail = std::to_string(grundlauf.gefallen) + " Test(s) sind schon ohne Mutation rot";
        return ergebnis;
    }
    ergebnis.basis_tests = grundlauf.gesamt;

    // (2) Die Mutanten, einzeln und jeder mit sofortiger Ruecknahme.
    for (const Mutant& mutant : mutanten) {
        MutantLaufErgebnis posten;
        posten.id     = std::string(mutant.id);
        posten.datei  = std::string(mutant.datei);
        posten.klasse = mutant.klasse;
        ++ergebnis.gefahren;

        const std::filesystem::path pfad = repo / std::filesystem::path(std::string(mutant.datei));

        const std::optional<std::string> original = lies_datei_ganz(pfad);
        if (!original.has_value()) {
            posten.diagnose = "Produktionsdatei nicht lesbar: " + pfad.string();
            ++ergebnis.harness_abbruch;
            ergebnis.je_mutant.push_back(posten);
            continue;
        }

        const ErsetzErgebnis mutiert =
            ersetze_genau(*original, mutant.suchen, mutant.ersetzen, mutant.erwartete_treffer);
        if (!mutiert.ok) {
            posten.diagnose = mutiert.diagnose;
            ++ergebnis.harness_abbruch;
            ergebnis.je_mutant.push_back(posten);
            continue;
        }
        if (!schreibe_datei_ganz(pfad, mutiert.inhalt)) {
            posten.diagnose = "Mutation nicht schreibbar: " + pfad.string();
            ++ergebnis.harness_abbruch;
            ergebnis.je_mutant.push_back(posten);
            continue;
        }

        // Ab hier ist der Baum veraendert -- JEDER Pfad unten fuehrt durch die Ruecknahme.
        if (!naht.baue()) {
            posten.ausgang  = MutantAusgang::VomBauGetoetet;
            posten.diagnose = "der Uebersetzer nahm den Mutanten -- die Suite kam nicht zum Zug";
            ++ergebnis.vom_bau_getoetet;
        } else {
            posten.befund = lies_ctest_befund(naht.fahre_suite());
            if (!posten.befund.zusammenfassung_gelesen) {
                posten.ausgang  = MutantAusgang::HarnessAbbruch;
                posten.diagnose = "ctest hat unter dem Mutanten keine Zusammenfassung geliefert";
                ++ergebnis.harness_abbruch;
            } else if (posten.befund.gefallen > 0) {
                posten.ausgang = MutantAusgang::VomTestGetoetet;
                ++ergebnis.vom_test_getoetet;
            } else {
                posten.ausgang = MutantAusgang::Ueberlebend;
                ++ergebnis.ueberlebend;
            }
            for (const std::string_view erwartet : mutant.erwartet_rot) {
                if (erwartet.empty()) continue;
                bool gefunden = false;
                for (const std::string& rot : posten.befund.rote_tests) {
                    if (rot == erwartet) {
                        gefunden = true;
                        break;
                    }
                }
                if (!gefunden) posten.vorhergesagt_aber_gruen.emplace_back(erwartet);
            }
        }

        // (3) DIE RUECKNAHME -- und ihr Nachweis: byte-weiser Vergleich der neu
        //     GELESENEN Datei gegen die gemerkten Originalbytes. Nicht "geschrieben,
        //     also gut"; erst das erneute Lesen ist die Aussage.
        const bool                       geschrieben = schreibe_datei_ganz(pfad, *original);
        const std::optional<std::string> nachher     = lies_datei_ganz(pfad);
        posten.byte_gleich_zurueckgenommen           = geschrieben && nachher.has_value() && *nachher == *original;
        ergebnis.je_mutant.push_back(posten);

        if (!posten.byte_gleich_zurueckgenommen) {
            // HARTER STOPP. Ein Harness, der den Baum veraendert zurueckliess, darf
            // nicht weiterlaufen und schon gar kein Ergebnis melden.
            ergebnis.abbruch        = LaufAbbruchGrund::RuecknahmeNichtByteGleich;
            ergebnis.abbruch_detail = pfad.string();
            return ergebnis;
        }
    }

    // (4) DIE FREMDE GEGENPROBE (T-3): nicht der Harness sagt "sauber", sondern git.
    const std::string status_nachher = naht.arbeitsbaum_status();
    if (!status_nachher.empty()) {
        ergebnis.abbruch        = LaufAbbruchGrund::BaumSchmutzigNachher;
        ergebnis.abbruch_detail = status_nachher;
        return ergebnis;
    }

    // (5) Das Bauverzeichnis wieder auf den gesunden Baum bringen -- sonst blieben die
    //     Binaries des letzten Mutanten liegen und der naechste Lauf misst Altbestand.
    if (!naht.baue()) {
        ergebnis.abbruch        = LaufAbbruchGrund::GrundlaufBauRot;
        ergebnis.abbruch_detail = "Wiederherstellungs-Bau nach dem letzten Mutanten ist rot";
        return ergebnis;
    }

    if (!ergebnis.nenner_haelt()) {
        ergebnis.abbruch        = LaufAbbruchGrund::GrundlaufLeererNenner;
        ergebnis.abbruch_detail = "gefahren != vom_bau + vom_test + ueberlebend + abbruch";
        return ergebnis;
    }

    // UEBERLEBENDE SIND EIN RISS, KEIN GRUEN. Der Harness misst die Suite; ist sie an
    // einer Stelle blind, ist das das Ergebnis und nicht ein Nebensatz.
    if (ergebnis.harness_abbruch > 0) {
        ergebnis.status = WacheStatus::Abbruch;
    } else if (ergebnis.ueberlebend > 0) {
        ergebnis.status = WacheStatus::Riss;
    } else {
        ergebnis.status = WacheStatus::Gruen;
    }
    return ergebnis;
}

std::string MutationsLaufErgebnis::protokoll() const {
    std::ostringstream aus;
    const std::string  NAME = "ci_mutations_lauf";

    if (abbruch.has_value()) {
        aus << NAME << ": ABBRUCH -- " << lauf_abbruch_text(*abbruch) << '\n';
        if (!abbruch_detail.empty()) aus << "  Diagnose: " << abbruch_detail << '\n';
        aus << "MUTATIONS-NENNER: " << katalog_gesamt << " Mutanten im Katalog, " << gefahren
            << " gefahren, 0 beurteilt.\n";
        return aus.str();
    }

    aus << NAME << ": " << gefahren << " Mutanten gefahren gegen eine Suite von " << basis_tests
        << " Tests je Lauf\n\n";
    for (const MutantLaufErgebnis& posten : je_mutant) {
        aus << "  " << posten.id << "  [" << klasse_text(posten.klasse) << "]\n";
        aus << "      Datei      : " << posten.datei << '\n';
        aus << "      Ausgang    : " << ausgang_text(posten.ausgang) << '\n';
        aus << "      Suite      : " << posten.befund.gefallen << " von " << posten.befund.gesamt << " Tests rot\n";
        if (!posten.befund.rote_tests.empty()) {
            aus << "      Rot        :";
            for (const std::string& rot : posten.befund.rote_tests) aus << ' ' << rot;
            aus << '\n';
        }
        if (!posten.vorhergesagt_aber_gruen.empty()) {
            aus << "      VORHERSAGE VERFEHLT (vorhergesagt rot, blieb gruen):";
            for (const std::string& t : posten.vorhergesagt_aber_gruen) aus << ' ' << t;
            aus << '\n';
        }
        aus << "      Ruecknahme : " << (posten.byte_gleich_zurueckgenommen ? "byte-gleich" : "NICHT byte-gleich")
            << '\n';
        if (!posten.diagnose.empty()) aus << "      Diagnose   : " << posten.diagnose << '\n';
    }

    aus << '\n';
    aus << "-----------------------------------------------------------------------------\n";
    aus << "MUTATIONS-NENNER (nie eine nackte Quote):\n";
    aus << "  " << katalog_gesamt << " Mutanten im Katalog, " << gefahren << " gefahren.\n";
    aus << "  " << vom_test_getoetet << " von der SUITE getoetet, " << vom_bau_getoetet << " vom UEBERSETZER getoetet, "
        << ueberlebend << " UEBERLEBEND, " << harness_abbruch << " Harness-Abbruch.\n";
    aus << "  Suite-Nenner: " << basis_tests << " Tests je Lauf (aus der ctest-Zusammenfassung).\n";
    aus << "  UEBERLEBENSRATE: " << ueberlebend << " von " << gefahren
        << " gefahrenen Mutanten ueberleben die Suite.\n";
    aus << "  (Ein vom Uebersetzer getoeteter Mutant ist KEIN Beleg fuer Test-Deckung -- die\n";
    aus << "   Suite kam bei ihm nie zum Zug. Deshalb stehen die beiden Zahlen getrennt.)\n";
    aus << "-----------------------------------------------------------------------------\n";
    aus << NAME << ": " << status_text(status);
    if (status == WacheStatus::Riss) {
        aus << " -- " << ueberlebend << " Mutant(en) ueberleben; die Suite ist dort BLIND.";
    }
    aus << '\n';
    return aus.str();
}

} // namespace comdare::ci_wachen
