// test_ci_wache_invarianten.cpp -- die zwei Abschalt-Klassen unter Test.  (2026-08-10)
// =============================================================================
// OWNER-AUFTRAG 10.08.2026, woertlich: "Er baut immer ... beide compiler Pflicht!
// Gebaut wird immer, skip ist VERBOTEN."
//
// Ein Job, der nicht laeuft, erzeugt keine Warnungen und keine Befunde -- und die
// Pipeline ist gruen. Diese Wache haelt die zwei Wege fest, auf denen ein Job WORTLOS
// aufhoert zu existieren. Die Sach-Begruendung beider Klassen steht vollstaendig im
// Kopf von Code/ci_wachen/include/comdare/ci_wachen/ci_invarianten.hpp.
//
// WAS HIER GEPRUEFT WIRD UND WAS NICHT -- beide Mengen, wie verlangt:
//   GEPRUEFT      die .gitlab-ci.yml, die DIESES Repository besitzt (super), und zwar
//                 vollstaendig: jeder Top-Level-Schluessel, jede Regel-Variable.
//   NICHT GEPRUEFT  die ce-.gitlab-ci.yml (eigenes Repository; sie traegt die gleiche
//                 Wache in ihrem eigenen Bau) und alles, was aus `include:` kommt --
//                 super erbt `.build-clang-latest` aus comdare/cluster/ci-templates,
//                 eine Dublette DORT bleibt fuer jede repo-lokale Wache unsichtbar.
//
// DER KOEDER (K13) WIRD GEWUERFELT, NICHT ABGESCHRIEBEN. Jeder Koeder-Fall zieht seinen
// Namen frisch aus /dev/urandom (ueber die Werkbank) und fordert ihn woertlich zurueck.
// Ein Orakel, das eine feste Zahl abschreibt, faellt daran.
//
// DER GEGENORAKEL-FALL ist der wichtigste dieser Datei: er baut den im Auftrag
// vorgeschriebenen Einzeiler nach und BELEGT AM SELBEN KOEDER, dass dieser die
// Template-Dublette nicht findet. Die Wache ist damit nicht "auch gut", sondern
// nachweislich weiter als ihre Vorgabe.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <algorithm>
#include <cstdio>
#include <filesystem>
#include <map>
#include <set>
#include <string>
#include <vector>

#include <gtest/gtest.h>

#include "comdare/ci_wachen/ci_invarianten.hpp"
#include "comdare/ci_wachen/ci_yml_scanner.hpp"
#include "comdare/ci_wachen/werkbank.hpp"

namespace {

using comdare::ci_wachen::Dublette;
using comdare::ci_wachen::finde_dubletten;
using comdare::ci_wachen::lies_zeilen;
using comdare::ci_wachen::nur_templates;
using comdare::ci_wachen::sammle_extern_annotationen;
using comdare::ci_wachen::sammle_gesetzte_variablen;
using comdare::ci_wachen::sammle_regel_referenzen;
using comdare::ci_wachen::sammle_top_level_schluessel;
using comdare::ci_wachen::ungedeckte_regel_variablen;
using comdare::ci_wachen::werkbank::Wuerfel;

// UNTERGRENZEN (D2-Muster): sie trennen "nichts gefunden, weil nichts da ist" von
// "nichts gefunden, weil der Scanner nichts sieht". Beide Zahlen sind am Objekt
// gemessen (10.08.2026, super .gitlab-ci.yml) und bewusst als UNTERGRENZE gesetzt --
// die Datei darf wachsen, ohne diesen Test zu bewegen.
constexpr std::size_t kMindestensSchluessel = 50; // gemessen 55
constexpr std::size_t kMindestensTemplates  = 5;  // gemessen 7
constexpr std::size_t kMindestensReferenzen = 10; // gemessen: s. Protokollzeile

std::vector<std::string> super_yml() {
    const auto zeilen = lies_zeilen(std::filesystem::path(COMDARE_CI_YML_PFAD));
    EXPECT_TRUE(zeilen.has_value()) << "FAIL-CLOSED: " << COMDARE_CI_YML_PFAD << " nicht lesbar";
    return zeilen.value_or(std::vector<std::string>{});
}

std::string dubletten_text(const std::vector<Dublette>& d) {
    std::string s;
    for (const auto& e : d) {
        s += "\n    " + e.name + " @";
        for (const auto z : e.zeilen) {
            s += " " + std::to_string(z);
        }
    }
    return s;
}

// DAS GEGENORAKEL: der im Auftrag vorgeschriebene Einzeiler, nachgebaut.
//     grep -oE '^[a-z][a-z0-9_:.-]*:' | sort | uniq -d
// Er steht hier NICHT als Wache, sondern als Vergleichsmass -- ein Fall belegt an
// einem gewuerfelten Koeder, was er nicht sieht.
std::vector<std::string> einzeiler_dubletten(const std::vector<std::string>& zeilen) {
    std::vector<std::string> treffer;
    for (const auto& zeile : zeilen) {
        if (zeile.empty()) {
            continue;
        }
        const char c0 = zeile[0];
        if (c0 < 'a' || c0 > 'z') {
            continue; // GENAU die Einschraenkung: nur Kleinbuchstaben am Anfang
        }
        std::size_t i = 1;
        while (i < zeile.size()) {
            const char c = zeile[i];
            const bool erlaubt = (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_' || c == ':' ||
                                 c == '.' || c == '-';
            if (!erlaubt) {
                break;
            }
            ++i;
        }
        // Das Muster endet zwingend auf ':' -- der letzte gefressene Doppelpunkt.
        std::size_t ende = zeile.rfind(':', i == 0 ? 0 : i - 1);
        if (ende == std::string::npos || ende == 0) {
            continue;
        }
        treffer.push_back(zeile.substr(0, ende + 1));
    }
    std::sort(treffer.begin(), treffer.end());
    std::vector<std::string> doppelt;
    for (std::size_t i = 1; i < treffer.size(); ++i) {
        if (treffer[i] == treffer[i - 1] && (doppelt.empty() || doppelt.back() != treffer[i])) {
            doppelt.push_back(treffer[i]);
        }
    }
    return doppelt;
}

} // namespace

// ---------------------------------------------------------------------------
// KLASSE 1 (I1): kein Top-Level-Schluessel steht zweimal.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, KeinTopLevelSchluesselStehtZweimal) {
    const auto zeilen     = super_yml();
    const auto schluessel = sammle_top_level_schluessel(zeilen);
    const auto templates  = nur_templates(schluessel);
    const auto doppelt    = finde_dubletten(schluessel);

    std::printf("[ NENNER   ] Datei=%s  Zeilen=%zu  Top-Level-Schluessel=%zu  davon Templates=%zu  Dubletten=%zu\n",
                COMDARE_CI_YML_PFAD, zeilen.size(), schluessel.size(), templates.size(), doppelt.size());

    // Stille-Null-Riegel: haette der Scanner nichts verstanden, waere "0 Dubletten"
    // ebenfalls wahr -- und wertlos.
    ASSERT_GE(schluessel.size(), kMindestensSchluessel)
        << "Der Scanner sieht zu wenige Schluessel -- 0 Dubletten waere hier eine stille Null.";

    EXPECT_TRUE(doppelt.empty()) << "Doppelter Top-Level-Schluessel: YAML gibt dem LETZTEN recht, der erste\n"
                                 << "verschwindet WORTLOS. Genau so lief contract:axis-version-lock drei\n"
                                 << "Wochen in keinem Job." << dubletten_text(doppelt);
}

// ---------------------------------------------------------------------------
// REICHWEITE: die Templates stehen mit in der Forderung. Sie sind die Menge, die
// der vorgeschriebene Einzeiler strukturell nicht sehen kann.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, TemplateSchluesselStehenMitInDerForderung) {
    const auto zeilen     = super_yml();
    const auto schluessel = sammle_top_level_schluessel(zeilen);
    const auto templates  = nur_templates(schluessel);

    std::size_t extends_nutzer = 0;
    for (const auto& z : zeilen) {
        if (!comdare::ci_wachen::ist_kommentarzeile(z) && z.find("extends:") != std::string::npos) {
            ++extends_nutzer;
        }
    }
    std::printf("[ NENNER   ] Templates=%zu  extends-Nutzer=%zu  (ein doppeltes Template verschiebt die rules\n"
                "             JEDES erbenden Jobs auf einmal)\n",
                templates.size(), extends_nutzer);

    EXPECT_GE(templates.size(), kMindestensTemplates)
        << "Keine Templates erfasst -- dann deckt diese Wache genau den Fall nicht ab,\n"
           "fuer den sie weiter greift als ihre Vorgabe.";
}

// ---------------------------------------------------------------------------
// KOEDER 1a (K13, beidseitig): doppelter JOB-Schluessel. Der Name wird gewuerfelt.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, KoederDoppelterJobSchluesselBeisst) {
    Wuerfel    wuerfel;
    const auto zeilen = super_yml();
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));

    // GEGENSEITE ZUERST: der unmutierte Stand ist sauber.
    ASSERT_TRUE(finde_dubletten(sammle_top_level_schluessel(zeilen)).empty())
        << "Vorbedingung verletzt: der Bestand traegt schon eine Dublette.";

    const std::string koeder = "koeder" + wuerfel.token(10);
    auto              mutiert = zeilen;
    mutiert.push_back(koeder + ":");
    mutiert.push_back("  stage: analyse");
    mutiert.push_back(koeder + ":");
    mutiert.push_back("  stage: analyse");

    const auto gefunden = finde_dubletten(sammle_top_level_schluessel(mutiert));
    std::printf("[ KOEDER   ] Job-Dublette '%s' -> gefunden=%zu\n", koeder.c_str(), gefunden.size());

    ASSERT_EQ(gefunden.size(), 1U) << "Der Koeder muss GENAU einmal beissen." << dubletten_text(gefunden);
    EXPECT_EQ(gefunden[0].name, koeder) << "Die Wache muss den gewuerfelten Namen woertlich nennen.";
    EXPECT_EQ(gefunden[0].zeilen.size(), 2U) << "Beide Fundstellen gehoeren in die Meldung, nicht nur eine.";
}

// ---------------------------------------------------------------------------
// KOEDER 1b (K13) + GEGENORAKEL: doppeltes TEMPLATE. Dieselbe Mutation, zwei
// Messungen -- diese Wache beisst, der vorgeschriebene Einzeiler nicht.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, KoederDoppeltesTemplateBeisstUndDerEinzeilerNicht) {
    Wuerfel    wuerfel;
    const auto zeilen = super_yml();
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));

    const std::string koeder = ".koeder" + wuerfel.token(10);
    auto              mutiert = zeilen;
    mutiert.push_back(koeder + ":");
    mutiert.push_back("  tags: [baremetal]");
    mutiert.push_back(koeder + ":");
    mutiert.push_back("  tags: [baremetal]");

    const auto gefunden  = finde_dubletten(sammle_top_level_schluessel(mutiert));
    const auto einzeiler = einzeiler_dubletten(mutiert);

    std::printf("[ KOEDER   ] Template-Dublette '%s' -> diese Wache=%zu   vorgeschriebener Einzeiler=%zu\n",
                koeder.c_str(), gefunden.size(), einzeiler.size());

    ASSERT_EQ(gefunden.size(), 1U) << "Template-Dublette nicht gefunden." << dubletten_text(gefunden);
    EXPECT_EQ(gefunden[0].name, koeder);

    // DAS GEGENORAKEL: derselbe Koeder, das vorgeschriebene Muster -- und es schweigt.
    EXPECT_TRUE(einzeiler.empty())
        << "Unerwartet: der `^[a-z]`-Einzeiler hat die Template-Dublette doch gesehen.\n"
           "Dann ist die Begruendung fuer die groessere Reichweite dieser Wache falsch und\n"
           "gehoert korrigiert -- nicht der Test.";
}

// ---------------------------------------------------------------------------
// KLASSE 2 (I2): jede Regel-Variable ist gedeckt -- gesetzt oder mit Grund extern.
// DIESER FALL WAR AM 10.08.2026 ROT (17 ungedeckte) UND HAT DIE ANNOTATIONEN
// AUSGELOEST. Er ist der rote Test, der vor dem Bau stand.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, JedeRegelVariableIstGedeckt) {
    const auto zeilen     = super_yml();
    const auto referenzen = sammle_regel_referenzen(zeilen);
    const auto gesetzt    = sammle_gesetzte_variablen(zeilen);
    const auto annotiert  = sammle_extern_annotationen(zeilen);
    const auto ungedeckt  = ungedeckte_regel_variablen(zeilen);

    std::set<std::string> eindeutig;
    for (const auto& r : referenzen) {
        eindeutig.insert(r.name);
    }
    std::printf("[ NENNER   ] Regel-Referenzen=%zu (eindeutig %zu)  gesetzt=%zu  extern-annotiert=%zu  "
                "ungedeckt=%zu\n",
                referenzen.size(), eindeutig.size(), gesetzt.size(), annotiert.size(), ungedeckt.size());

    ASSERT_GE(referenzen.size(), kMindestensReferenzen)
        << "Der Scanner findet fast keine Regel-Variablen -- 0 ungedeckte waere eine stille Null.";

    std::string liste;
    for (const auto& u : ungedeckt) {
        liste += "\n    " + u.name + "  (erste Fundstelle Zeile " + std::to_string(u.zeile) + ")";
    }
    EXPECT_TRUE(ungedeckt.empty())
        << "Regel-Variable weder gesetzt noch mit Grund als extern erklaert. Ein solches\n"
           "Gate ist von einem abgeschalteten Job nicht zu unterscheiden -- genau so hielt\n"
           "COMDARE_AXIS_LOCK_CHECK den doppelten Schluessel am Leben.\n"
           "Deckung: entweder im variables-Block setzen, oder eine Zeile\n"
           "    # extern: <NAME> -- <woher der Wert kommt>\n"
           "Ungedeckt:"
        << liste;
}

// ---------------------------------------------------------------------------
// KOEDER 2 (K13, beidseitig): eine gewuerfelte, nirgends gesetzte Regel-Variable.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, KoederUngedeckteRegelVariableBeisst) {
    Wuerfel    wuerfel;
    const auto zeilen = super_yml();
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));

    // GEMESSEN STATT ANGENOMMEN: der Fall rechnet die DIFFERENZ, nicht den Absolutwert.
    // Der erste Entwurf verlangte hier `== 1` und war rot, weil der Bestand selbst noch
    // ungedeckte Variablen trug (9 am 10.08.). Ein Koeder-Orakel, das eine saubere
    // Grundlinie voraussetzt, misst die Grundlinie mit -- nicht den Koeder.
    const auto        vorher = ungedeckte_regel_variablen(zeilen);
    const std::string name   = "COMDARE_KOEDER_" + wuerfel.token(10);
    auto              mutiert = zeilen;
    mutiert.push_back("job:koeder:");
    mutiert.push_back("  rules:");
    mutiert.push_back("    - if: '$" + name + " == \"1\"'");

    const auto mit = ungedeckte_regel_variablen(mutiert);
    std::printf("[ KOEDER   ] ungesetzte Regel-Variable '%s' -> vorher=%zu  nachher=%zu\n", name.c_str(),
                vorher.size(), mit.size());

    ASSERT_EQ(mit.size(), vorher.size() + 1) << "Der Koeder muss GENAU einen neuen Befund erzeugen.";
    const bool genannt = std::any_of(mit.begin(), mit.end(), [&](const auto& f) { return f.name == name; });
    EXPECT_TRUE(genannt) << "Die Wache muss den gewuerfelten Namen woertlich nennen.";

    // GEGENSEITE A: dieselbe Variable, aber mit Grund als extern erklaert -> gedeckt.
    auto mit_annotation = mutiert;
    mit_annotation.push_back("# extern: " + name + " -- kommt aus der Trigger-Nutzlast");
    EXPECT_EQ(ungedeckte_regel_variablen(mit_annotation).size(), vorher.size())
        << "Die Annotation muss GENAU ihren Befund aufheben -- nicht mehr und nicht weniger.";

    // GEGENSEITE B: dieselbe Variable, aber im variables-Block gesetzt -> gedeckt.
    auto mit_setzung = mutiert;
    mit_setzung.push_back("variables:");
    mit_setzung.push_back("  " + name + ": \"1\"");
    EXPECT_EQ(ungedeckte_regel_variablen(mit_setzung).size(), vorher.size())
        << "Eine Setzung muss den Befund aufheben.";
}

// ---------------------------------------------------------------------------
// DIE ANNOTATION DARF KEIN FREIBRIEF SEIN -- zwei Faelle, die genau das festhalten.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, AnnotationIstNamensgebundenUndBrauchtEinenGrund) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string a = "COMDARE_KOEDER_A" + wuerfel.token(8);
    const std::string b = "COMDARE_KOEDER_B" + wuerfel.token(8);

    std::vector<std::string> basis{
        "job:koeder:",
        "  rules:",
        "    - if: '$" + a + " == \"1\"'",
        "    - if: '$" + b + " == \"1\"'",
    };

    // (1) NAMENSGEBUNDEN: die Annotation fuer A deckt B nicht mit.
    auto nur_a = basis;
    nur_a.push_back("# extern: " + a + " -- Projekt-Variable");
    const auto rest = ungedeckte_regel_variablen(nur_a);
    std::printf("[ KOEDER   ] Annotation nur fuer '%s' -> weiterhin ungedeckt=%zu\n", a.c_str(), rest.size());
    ASSERT_EQ(rest.size(), 1U) << "Eine Annotation darf nur ihren eigenen Namen decken.";
    EXPECT_EQ(rest[0].name, b);

    // (2) BEGRUENDUNGSPFLICHT: ohne "-- Grund" deckt sie nichts.
    auto ohne_grund = basis;
    ohne_grund.push_back("# extern: " + a);
    ohne_grund.push_back("# extern: " + b + " --   ");
    EXPECT_EQ(ungedeckte_regel_variablen(ohne_grund).size(), 2U)
        << "Eine Annotation ohne Begruendung ist nur eine hoeflichere Form des Verschweigens.";
}

// ---------------------------------------------------------------------------
// FAIL-CLOSED (Hausregel): "Datei weg" und "Datei leer" duerfen nicht denselben
// Wert haben. Sonst meldet eine verlorene Datei 0 Dubletten und alles ist gruen.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, FehlendeDateiIstFailClosedUndNichtLeer) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::filesystem::path weg =
        std::filesystem::temp_directory_path() / ("nicht-vorhanden-" + wuerfel.token(12) + ".yml");

    ASSERT_FALSE(std::filesystem::exists(weg));
    const auto zeilen = lies_zeilen(weg);
    std::printf("[ NENNER   ] fehlende Datei -> has_value=%d (erwartet 0)\n", static_cast<int>(zeilen.has_value()));
    EXPECT_FALSE(zeilen.has_value()) << "Eine fehlende Datei muss nullopt liefern, nie eine leere Zeilenliste.";
}
