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
//   NICHT GEPRUEFT  die ce-.gitlab-ci.yml (eigenes Repository) und alles, was aus
//                 `include:` kommt -- super erbt `.build-clang-latest` aus
//                 comdare/cluster/ci-templates, eine Dublette DORT bleibt fuer jede
//                 repo-lokale Wache unsichtbar.
//
// DIE ce-SEITE IST UNGEDECKT, UND ZWAR GEMESSEN.  (Korrektur 11.08.2026)
//   Hier stand bis heute der Zusatz, ce trage "die gleiche Wache in ihrem eigenen Bau".
//   Das war eine Zusicherung ueber ein fremdes Repository, die niemand prueft -- genau
//   die Klasse, gegen die dieses Paket gebaut ist. Am Objekt nachgemessen, ce gepinnt
//   auf 670483c0 (Code/external/comdare-cache-engine):
//     - ce hat KEINE ci_wachen-Bibliothek. 0 Treffer fuer "ci_wachen" und "invarianten"
//       in 5782 versionierten Dateien (Gegenprobe: dieselbe Suche findet 822 .cpp).
//     - KLASSE 1 deckt ce mit einem SHELL-Skript ab, scripts/ci_yaml_key_guard.sh,
//       aufgerufen als Job-Schritt (ce .gitlab-ci.yml:363) -- NICHT im Bau: 0 Treffer in
//       ce-CMake (Gegenprobe: 13 CMakeLists tragen add_test). Ein anderes Werkzeug,
//       eine andere Stufe, nicht "die gleiche Wache".
//     - KLASSE 2 deckt ce GAR NICHT ab: 0 `# extern:`-Annotationen in ce.
//   Solange das so ist, deckt DIESE Datei super und nur super. Wer die ce-Seite decken
//   will, baut sie dort -- eine Behauptung hier deckt sie nicht.
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
        for (const auto z : e.zeilen) { s += " " + std::to_string(z); }
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
        if (zeile.empty()) { continue; }
        const char c0 = zeile[0];
        if (c0 < 'a' || c0 > 'z') {
            continue; // GENAU die Einschraenkung: nur Kleinbuchstaben am Anfang
        }
        std::size_t i = 1;
        while (i < zeile.size()) {
            const char c = zeile[i];
            const bool erlaubt =
                (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_' || c == ':' || c == '.' || c == '-';
            if (!erlaubt) { break; }
            ++i;
        }
        // Das Muster endet zwingend auf ':' -- der letzte gefressene Doppelpunkt.
        std::size_t ende = zeile.rfind(':', i == 0 ? 0 : i - 1);
        if (ende == std::string::npos || ende == 0) { continue; }
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
        if (!comdare::ci_wachen::ist_kommentarzeile(z) && z.find("extends:") != std::string::npos) { ++extends_nutzer; }
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

    const std::string koeder  = "koeder" + wuerfel.token(10);
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

    const std::string koeder  = ".koeder" + wuerfel.token(10);
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
    EXPECT_TRUE(einzeiler.empty()) << "Unerwartet: der `^[a-z]`-Einzeiler hat die Template-Dublette doch gesehen.\n"
                                      "Dann ist die Begruendung fuer die groessere Reichweite dieser Wache falsch und\n"
                                      "gehoert korrigiert -- nicht der Test.";
}

// ---------------------------------------------------------------------------
// KLASSE 2 (I2): jede Regel-Variable ist gedeckt -- gesetzt oder mit Grund extern.
// DIESER FALL WAR ROT, BEVOR DIE ANNOTATIONEN GESCHRIEBEN WAREN. Er ist der rote Test,
// der vor dem Bau stand.
// NENNER-KORREKTUR 11.08.2026: hier stand "17 ungedeckte". Diese Zahl stammt aus keinem
// Lauf dieser Wache -- der Code lieferte am 10.08. NEUN, passend zu den neun damaligen
// Annotationen. Seit die Weiterreichung `COMDARE_X: "$COMDARE_X"` nicht mehr als Setzung
// zaehlt (s. KoederDurchreichungIstKeineSetzung), sind es ZEHN: COMDARE_MEASURE_PROFILE
// kam dazu. Die Protokollzeile unten nennt beide Zahlen bei jedem Lauf selbst.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, JedeRegelVariableIstGedeckt) {
    const auto zeilen     = super_yml();
    const auto referenzen = sammle_regel_referenzen(zeilen);
    const auto gesetzt    = sammle_gesetzte_variablen(zeilen);
    const auto annotiert  = sammle_extern_annotationen(zeilen);
    const auto ungedeckt  = ungedeckte_regel_variablen(zeilen);

    std::set<std::string> eindeutig;
    for (const auto& r : referenzen) { eindeutig.insert(r.name); }
    std::printf("[ NENNER   ] Regel-Referenzen=%zu (eindeutig %zu)  gesetzt=%zu  extern-annotiert=%zu  "
                "ungedeckt=%zu\n",
                referenzen.size(), eindeutig.size(), gesetzt.size(), annotiert.size(), ungedeckt.size());

    ASSERT_GE(referenzen.size(), kMindestensReferenzen)
        << "Der Scanner findet fast keine Regel-Variablen -- 0 ungedeckte waere eine stille Null.";

    std::string liste;
    for (const auto& u : ungedeckt) {
        liste += "\n    " + u.name + "  (erste Fundstelle Zeile " + std::to_string(u.zeile) + ")";
    }
    EXPECT_TRUE(ungedeckt.empty()) << "Regel-Variable weder gesetzt noch mit Grund als extern erklaert. Ein solches\n"
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
    const auto        vorher  = ungedeckte_regel_variablen(zeilen);
    const std::string name    = "COMDARE_KOEDER_" + wuerfel.token(10);
    auto              mutiert = zeilen;
    mutiert.push_back("job:koeder:");
    mutiert.push_back("  rules:");
    mutiert.push_back("    - if: '$" + name + " == \"1\"'");

    const auto mit = ungedeckte_regel_variablen(mutiert);
    std::printf("[ KOEDER   ] ungesetzte Regel-Variable '%s' -> vorher=%zu  nachher=%zu\n", name.c_str(), vorher.size(),
                mit.size());

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
// KOEDER 3 (K13, beidseitig): DIE WEITERREICHUNG IST KEINE SETZUNG.
// DER V-8-FALL DIESER WACHE -- welcher Zustand laesst "gedeckt" erscheinen, obwohl
// die Deckung fehlt? Antwort: `COMDARE_X: "$COMDARE_X"`. Die Zeile sieht aus wie eine
// Setzung und definiert nichts; sie gibt den Wert der ELTERN-Pipeline an eine Child
// weiter. Steht X sonst nirgends, ist das Gate genauso tot wie ohne die Zeile.
// AM OBJEKT: genau so meldete COMDARE_MEASURE_PROFILE gruen, obwohl es drei echte
// Regeln gatet und nirgends gesetzt ist -- die gehuetete Klasse in der Wache selbst.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, KoederDurchreichungIstKeineSetzung) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string name = "COMDARE_KOEDER_" + wuerfel.token(10);

    const std::vector<std::string> basis{
        "job:koeder:",
        "  rules:",
        "    - if: '$" + name + " == \"1\"'",
    };

    auto durchgereicht = basis; // ZUSTAND A: nur die Weiterreichung
    durchgereicht.push_back("  variables:");
    durchgereicht.push_back("    " + name + ": \"$" + name + "\"");

    auto gesetzt = basis; // ZUSTAND B: eine echte Setzung
    gesetzt.push_back("  variables:");
    gesetzt.push_back("    " + name + ": \"1\"");

    const auto ohne              = ungedeckte_regel_variablen(basis).size();
    const auto mit_durchreichung = ungedeckte_regel_variablen(durchgereicht).size();
    const auto mit_setzung       = ungedeckte_regel_variablen(gesetzt).size();

    std::printf("[ KOEDER   ] '%s': ohne=%zu  nur-Weiterreichung=%zu  echte Setzung=%zu\n", name.c_str(), ohne,
                mit_durchreichung, mit_setzung);

    ASSERT_EQ(ohne, 1U) << "Vorbedingung: die nackte Regel-Variable muss ungedeckt sein.";
    EXPECT_EQ(mit_durchreichung, 1U) << "Die Weiterreichung darf NICHT als Deckung zaehlen. Sie definiert\n"
                                        "nichts -- ohne Eltern-Wert ist das Gate so tot wie ohne die Zeile.";
    EXPECT_EQ(mit_setzung, 0U) << "Eine ECHTE Setzung muss weiterhin decken -- sonst ist die\n"
                                  "Unterscheidung zu scharf und die Wache unbrauchbar.";

    // GEGENSEITE: die Selbst-Referenz entwertet nur den EIGENEN Namen. Ein Wert, der eine
    // ANDERE Variable nennt, ist eine ganz normale Setzung und deckt weiterhin.
    const std::string anderer = "COMDARE_KOEDER_B" + wuerfel.token(8);
    auto              fremd   = basis;
    fremd.push_back("  variables:");
    fremd.push_back("    " + name + ": \"$" + anderer + "\"");
    EXPECT_EQ(ungedeckte_regel_variablen(fremd).size(), 0U)
        << "Ein Wert, der eine ANDERE Variable nennt, ist eine Setzung und deckt.";
}

// ---------------------------------------------------------------------------
// DIE ANNOTATION DARF NICHT INS LEERE ZEIGEN.
// Eine `# extern:`-Zeile ist nur dann eine Deckung, wenn es die gedeckte Sache gibt.
// Bleibt sie stehen, nachdem ihre Regel verschwunden ist, wird sie zum FREIBRIEF: der
// naechste Schalter gleichen Namens ist ab Zeile eins "gedeckt", ohne dass jemand
// hinsieht. Dieser Fall ist bewusst NICHT an Zeilennummern gebunden -- die verrutschen
// bei jeder Einfuegung still (bei dieser Landung waren 13 von 16 Belegzeilen daneben).
// Geprueft wird das Haltbare: der annotierte Name steht wirklich in einer rules-Bedingung.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, ExternAnnotationDecktEineWirklichGatendeVariable) {
    const auto zeilen     = super_yml();
    const auto annotiert  = sammle_extern_annotationen(zeilen);
    const auto referenzen = sammle_regel_referenzen(zeilen);

    std::set<std::string> gatend;
    for (const auto& r : referenzen) { gatend.insert(r.name); }
    std::vector<std::string> waisen;
    for (const auto& [name, grund] : annotiert) {
        if (gatend.count(name) == 0) { waisen.push_back(name); }
    }
    std::printf("[ NENNER   ] extern-Annotationen=%zu  mit echter rules-Bedingung=%zu  verwaist=%zu\n",
                annotiert.size(), annotiert.size() - waisen.size(), waisen.size());

    // Stille-Null-Riegel: ohne gelesene Annotationen waere "0 Waisen" ebenfalls wahr.
    ASSERT_FALSE(annotiert.empty()) << "Keine Annotation gelesen -- 0 Waisen waere hier eine stille Null.";

    std::string liste;
    for (const auto& w : waisen) { liste += "\n    " + w; }
    EXPECT_TRUE(waisen.empty()) << "Annotation ohne zugehoerige rules-Bedingung. Entweder ist der Name\n"
                                   "vertippt, oder die Regel ist weg und die Zeile blieb stehen -- dann\n"
                                   "deckt sie ab jetzt blind den naechsten Schalter gleichen Namens.\n"
                                   "Verwaist:"
                                << liste;
}

// ---------------------------------------------------------------------------
// KOEDER 4 (K13): eine Annotation, die nichts gatet, muss auffallen.
// ---------------------------------------------------------------------------
TEST(CiInvarianten, KoederVerwaisteAnnotationBeisst) {
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string name = "COMDARE_KOEDER_WAISE_" + wuerfel.token(8);

    // GEGENSEITE ZUERST: mit Regel ist der Name gedeckt UND gatet -- keine Waise.
    std::vector<std::string> mit_regel{
        "job:koeder:",
        "  rules:",
        "    - if: '$" + name + " == \"1\"'",
        "# extern: " + name + " -- Trigger-Nutzlast",
    };
    const auto referenzen = sammle_regel_referenzen(mit_regel);
    const bool gatet = std::any_of(referenzen.begin(), referenzen.end(), [&](const auto& r) { return r.name == name; });

    // KOEDER: dieselbe Annotation, aber die Regel fehlt.
    const std::vector<std::string> ohne_regel{
        "# extern: " + name + " -- Trigger-Nutzlast",
    };
    const auto annotiert_ohne  = sammle_extern_annotationen(ohne_regel);
    const auto referenzen_ohne = sammle_regel_referenzen(ohne_regel);

    std::printf("[ KOEDER   ] '%s': mit Regel gatet=%d   ohne Regel annotiert=%zu referenziert=%zu\n", name.c_str(),
                static_cast<int>(gatet), annotiert_ohne.size(), referenzen_ohne.size());

    EXPECT_TRUE(gatet) << "Vorbedingung: mit Regel muss der Name als Regel-Referenz erscheinen.";
    ASSERT_EQ(annotiert_ohne.size(), 1U) << "Die Annotation muss gelesen werden -- sonst misst der Fall nichts.";
    EXPECT_TRUE(referenzen_ohne.empty()) << "Ohne Regel darf es keine Regel-Referenz geben; genau diese\n"
                                            "Differenz macht die Waise sichtbar.";
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
