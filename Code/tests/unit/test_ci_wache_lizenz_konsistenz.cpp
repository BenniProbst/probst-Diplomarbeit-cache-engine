// SPDX-License-Identifier: Apache-2.0
// test_ci_wache_lizenz_konsistenz.cpp -- sagen NOTICE, LICENSE und der           (2026-08-11)
// Arbeitsbaum dasselbe ueber die Lizenzen dieses Repositoriums?
// =============================================================================
// WARUM ES DIESE DATEI GIBT (am Objekt gemessen, 11.08.2026, Stand afa5815a):
//
//   * `git log --all -- NOTICE` war LEER -- in KEINEM Branch dieses Repos hat je
//     eine NOTICE an der Wurzel existiert. Gegenprobe `git log --all -- LICENSE`
//     = 1 Commit, das Werkzeug greift also.
//   * Dabei zieht das Repo 4 .gitmodules-Einbindungen und 1544 getrackte Dateien
//     vendorten Forschungscode ein, darunter GPL-3.0 (P04-CoCo-trie,
//     P07-Wormhole) und LGPL-2.1-or-later (P29-RCU-McKenney). Die Wurzel-LICENSE
//     war unveraendertes Apache-Boilerplate und sagte darueber nichts.
//   * 0 von 18 Unit-Tests behandelten Lizenzen; scripts/, ci/, Code/ci_wachen/,
//     Makefile und .gitlab-ci.yml hatten 0 Treffer auf NOTICE/LICENSE/SPDX.
//
// DIE FEHLERKLASSE IST NICHT HYPOTHETISCH -- sie liegt LIVE im gepinnten
// cache-engine-Stand: ce/NOTICE:6-8 behauptet Apache-2.0, ce/LICENSE daneben
// traegt "Comdare Cache Engine -- Dual License". ZWEI DATEIEN, ZWEI AUSSAGEN,
// und nichts, was es merkt. Genau diese Klasse faengt der Fall
// FalscherMarkerIstRot -- und am echten Baum der Koeder K-C.
//
// AUFBAU (Praezedenz P3, test_ci_wache_guard_basis.cpp):
//   TEIL 1  In-Memory-Faelle des reinen Pruefkerns. Sie brauchen kein Repo und
//           stellen Zustaende her, die am echten Baum gar nicht herstellbar
//           waeren (z.B. 0 .gitmodules-Eintraege). Sie sind die PERMANENTEN
//           Koeder: sie beissen bei JEDEM ctest-Lauf, nicht nur am Bautag.
//   TEIL 2  Lauf am ECHTEN Repo ueber COMDARE_REPO_WURZEL_LIZENZ. Der Pfad kommt
//           als Define, NICHT aus dem Arbeitsverzeichnis -- dieselbe Haertung wie
//           test_279_tier_binary_report und test_ci_wache_registrierung (eine
//           CWD-Annahme ist keine Zusicherung).
//
// TESTKRITIK (T-9), ausdruecklich statt verschwiegen:
//   * Der Lizenz-Marker ist eine SUBSTRING-PROBE, keine juristische
//     Textanalyse. Er faengt einen Lizenz-WECHSEL (der Titel aendert sich),
//     aber nicht jeden Versions-Wechsel innerhalb derselben Familie: die
//     Boilerplate-Texte von Apache und GPL tragen den Titel in Zeile 1 und die
//     Version erst in Zeile 2. GPLv3 -> GPLv2 liesse den Titel-Marker stehen.
//     Benannt, nicht geschlossen.
//   * NICHT AUSGECHECKTE SUBMODULE werden nur GEPAART, nicht inhaltsgeprueft --
//     sonst waere die Wache auf jedem Klon ohne `git submodule update` konstant
//     rot (Doktrin: die Pipeline ist immer hart gruen). Am Objekt sind beide
//     Thesis-Einbindungen leer. Der Verzicht wird als SKIP protokolliert; der
//     Fall NichtAusgecheckesWirdNurGepaartUndProtokolliert friert beide Haelften
//     ein.
//   * Die Wache liest den ARBEITSBAUM, nicht die Historie.
//   * Der SPDX-Scan liest je Datei nur den Kopf (4096 Byte).
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <cstddef>
#include <filesystem>
#include <iostream>
#include <map>
#include <string>
#include <string_view>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/lizenz_konsistenz.hpp"

namespace {

using comdare::ci_wachen::BefundArt;
using comdare::ci_wachen::ergebnis_bericht;
using comdare::ci_wachen::hat_befund;
using comdare::ci_wachen::LizenzEingang;
using comdare::ci_wachen::LizenzErgebnis;
using comdare::ci_wachen::NoticeArt;
using comdare::ci_wachen::parse_gitmodules;
using comdare::ci_wachen::parse_notice;
using comdare::ci_wachen::pruefe;
using comdare::ci_wachen::sammle_vom_baum;
using comdare::ci_wachen::SpdxFund;
using comdare::ci_wachen::SubmodulAmBaum;
using comdare::ci_wachen::WacheStatus;

// =============================================================================
// TEIL 1 -- DER REINE PRUEFKERN
// =============================================================================

// DER GEGENKOEDER, an dem alle Faelle unten haengen: ein in sich stimmiger Satz.
// Er MUSS 0 Befunde liefern. Waere er das nicht, waeren alle Rot-Faelle unten
// wertlos -- sie koennten aus jedem beliebigen Grund rot sein.
LizenzEingang gesunder_satz() {
    LizenzEingang e;
    e.notice_vorhanden = true;
    // DATEI ist relativ zur genannten Komponente, <pfad> einer VENDOR-Zeile
    // relativ zu Forschungsarbeiten/code (Grammatik-Block im Header).
    e.notice_text =
        "Beispiel-NOTICE\n"
        "WACHE: SUBMODUL ext/alpha LIZENZ \"Alpha Public License\" DATEI LICENSE\n"
        "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
        "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
    e.gitmodules_text =
        "[submodule \"ext/alpha\"]\n"
        "\tpath = ext/alpha\n"
        "\turl = ../alpha.git\n"
        "[submodule \"ext/beta\"]\n"
        "\tpath = ext/beta\n"
        "\turl = ../beta.git\n";
    e.license_text =
        "                                 Apache License\n"
        "                           Version 2.0, January 2004\n"
        "\n"
        "GELTUNGSBEREICH DIESER LIZENZ -- EIGENCODE, SUBMODULE, VENDORED FORSCHUNGSCODE\n";
    e.submodule_am_baum = {
        {"ext/alpha", SubmodulAmBaum{true, true}},
        {"ext/beta", SubmodulAmBaum{true, false}},
    };
    e.vendor_am_baum = {{"P99-Gamma", "klon/LICENSE"}};
    e.dateiinhalt    = {
        {"ext/alpha/LICENSE", "Alpha Public License\nAlle Rechte irgendwem.\n"},
        {"Forschungsarbeiten/code/P99-Gamma/klon/LICENSE", "Gamma License\nVersion 1.\n"},
    };
    e.spdx_funde = {SpdxFund{"Code/a.cpp", "Apache-2.0"}, SpdxFund{"Code/b.hpp", "Apache-2.0"}};
    return e;
}

// -----------------------------------------------------------------------------
// K0 -- DER EINGEBAUTE GEGENKOEDER. Ohne ihn ist kein Rot-Fall unten aussagekraeftig.
// -----------------------------------------------------------------------------
TEST(LizenzKern, GesunderSatzLiefertNULLBefundeUndGRUEN) {
    const LizenzErgebnis r = pruefe(gesunder_satz());
    EXPECT_EQ(r.befunde.size(), 0U) << "Der gesunde Satz muss 0 Befunde liefern, sonst ist jeder Rot-Fall "
                                    << "unten mehrdeutig.\n"
                                    << ergebnis_bericht(r);
    EXPECT_EQ(r.status, WacheStatus::Gruen) << ergebnis_bericht(r);
    // Die Nenner gehoeren in die AUSGABE, nicht nur in den Kopf des Autors.
    EXPECT_EQ(r.nenner_gitmodules, 2U);
    EXPECT_EQ(r.nenner_vendor, 1U);
    EXPECT_EQ(r.nenner_spdx, 2U);
    EXPECT_EQ(r.nenner_notice_submodul, 2U);
    EXPECT_EQ(r.nenner_notice_vendor, 1U);
    EXPECT_EQ(r.skips.size(), 0U) << "Im gesunden Satz ist alles ausgecheckt -- kein SKIP erwartet.";
}

// -----------------------------------------------------------------------------
// K1 -- NOTICE FEHLT. Der Literal-Fehltext, an dem der Rot-Lauf vor der Heilung
// gemessen wurde.
// -----------------------------------------------------------------------------
TEST(LizenzKern, FehlendeNoticeIstRotMitLiteralFehltext) {
    LizenzEingang e   = gesunder_satz();
    e.notice_vorhanden = false;
    e.notice_text      = "";
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::NoticeFehlt)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("NOTICE fehlt an der Wurzel"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << "Eine fehlende NOTICE ist ein Riss, kein Gruen.\n"
                                           << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K2 (Koeder a) -- ERFUNDENER SUBMODUL-EINTRAG in NOTICE.
// -----------------------------------------------------------------------------
TEST(LizenzKern, ErfundenerSubmodulEintragIstRot) {
    LizenzEingang e = gesunder_satz();
    e.notice_text += "WACHE: SUBMODUL ext/gibtesnicht LIZENZ \"X\" DATEI LICENSE\n";
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::NoticeZeileOhneSubmodul)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("nicht in .gitmodules"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K3 (Koeder b) -- ECHTER .gitmodules-EINTRAG OHNE NOTICE-Zeile. Die zweite
// Richtung derselben Paarung; ohne sie waere die Wache einseitig.
// -----------------------------------------------------------------------------
TEST(LizenzKern, EchtesSubmodulOhneNoticeZeileIstRot) {
    LizenzEingang e = gesunder_satz();
    e.notice_text =
        "Beispiel-NOTICE\n"
        "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
        "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::SubmodulOhneNoticeZeile)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("Submodul ohne NOTICE-Zeile: ext/alpha"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K4 (Koeder c) -- FALSCHER MARKER. Das ist die KON2-25-Klasse in Reinform:
// zwei Dateien, zwei Aussagen.
// -----------------------------------------------------------------------------
TEST(LizenzKern, FalscherMarkerIstRot) {
    LizenzEingang e = gesunder_satz();
    e.dateiinhalt["ext/alpha/LICENSE"] = "Alpha Dual License\nGanz andere Bedingungen.\n";
    const LizenzErgebnis r             = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::MarkerNichtInLizenzdatei)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("Marker nicht in Lizenzdatei"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K5 (Koeder d) -- LICENSE OHNE KLAUSEL-MARKER.
// -----------------------------------------------------------------------------
TEST(LizenzKern, LicenseOhneKlauselMarkerIstRot) {
    LizenzEingang e = gesunder_satz();
    e.license_text =
        "                                 Apache License\n"
        "                           Version 2.0, January 2004\n";
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::WurzelLizenzOhneKlauselMarker)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("Klausel-Marker fehlt"));
    EXPECT_FALSE(hat_befund(r, BefundArt::WurzelLizenzOhneApacheMarker))
        << "T-4-Gegeneingang: die Apache-Marker stehen noch da -- nur der Klausel-Marker fehlt. "
        << "Ein Test, der hier BEIDE Befunde saehe, wuerde die zwei Zusicherungen nicht trennen.\n"
        << ergebnis_bericht(r);
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K6 -- LICENSE OHNE APACHE-MARKER. Die Gegenrichtung zu K5: hier steht der
// Klausel-Marker, aber die Lizenz selbst ist ausgetauscht.
// -----------------------------------------------------------------------------
TEST(LizenzKern, LicenseOhneApacheMarkerIstRot) {
    LizenzEingang e = gesunder_satz();
    e.license_text =
        "GNU GENERAL PUBLIC LICENSE\n"
        "GELTUNGSBEREICH DIESER LIZENZ -- EIGENCODE, SUBMODULE, VENDORED FORSCHUNGSCODE\n";
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::WurzelLizenzOhneApacheMarker)) << ergebnis_bericht(r);
    EXPECT_FALSE(hat_befund(r, BefundArt::WurzelLizenzOhneKlauselMarker)) << ergebnis_bericht(r);
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K7 (Koeder e) -- EIN SPDX-AUSREISSER unter Code/.
// -----------------------------------------------------------------------------
TEST(LizenzKern, SpdxAusreisserIstRot) {
    LizenzEingang e = gesunder_satz();
    // Der Wert wird als DATENFELD gesetzt, nicht als SPDX-Textzeile geschrieben:
    // diese Testdatei liegt selbst unter Code/ und wird vom Objekt-Teil gescannt.
    // Eine echte Ausreisser-Zeile hier waere ein selbstgebauter Dauer-Rotstand.
    e.spdx_funde.push_back(SpdxFund{"Code/c.cpp", "GPL-3.0-only"});
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::SpdxAbweichler)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("SPDX-Abweichler: Code/c.cpp"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K8 -- VENDOR-ZEILE OHNE PROJEKT AM BAUM.
// -----------------------------------------------------------------------------
TEST(LizenzKern, VendorZeileOhneProjektAmBaumIstRot) {
    LizenzEingang e = gesunder_satz();
    e.notice_text += "WACHE: VENDOR P98-Weg LIZENZ \"Weg License\" DATEI LICENSE\n";
    const LizenzErgebnis r = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::NoticeZeileOhneLizenzdatei)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("VENDOR-Zeile ohne Projekt"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K9 -- NEUES VENDOR-PROJEKT OHNE NOTICE-ZEILE. Das ist die Richtung, die beim
// naechsten eingebrachten Fremdprojekt zuschnappt.
// -----------------------------------------------------------------------------
TEST(LizenzKern, NeuesVendorProjektOhneNoticeZeileIstRot) {
    LizenzEingang e                        = gesunder_satz();
    e.vendor_am_baum["P97-Neu"]            = "LICENSE";
    const LizenzErgebnis r                 = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::VendorProjektOhneNoticeZeile)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("Vendor-Projekt ohne NOTICE-Zeile: P97-Neu"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K10 -- KEINE-LIZENZDATEI BEHAUPTET, OBWOHL EINE DALIEGT.
// -----------------------------------------------------------------------------
TEST(LizenzKern, KeineLizenzdateiObwohlEineDaliegtIstRot) {
    LizenzEingang e                             = gesunder_satz();
    e.submodule_am_baum["ext/beta"].hat_lizenzdatei = true;
    const LizenzErgebnis r                      = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::KeineLizenzdateiObwohlVorhanden)) << ergebnis_bericht(r);
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K11 -- NICHT AUSGECHECKT: die Paarung bleibt, die Inhaltspruefung entfaellt,
// und der Verzicht wird PROTOKOLLIERT. Beide Haelften stehen hier, weil nur die
// zweite den Unterschied zwischen "bewusster Verzicht" und "verdeckte Null" macht.
// -----------------------------------------------------------------------------
TEST(LizenzKern, NichtAusgecheckesWirdNurGepaartUndProtokolliert) {
    LizenzEingang e                        = gesunder_satz();
    e.submodule_am_baum["ext/alpha"]       = SubmodulAmBaum{false, false};
    e.dateiinhalt.erase("ext/alpha/LICENSE"); // am Baum waere die Datei ebenfalls weg
    const LizenzErgebnis r                 = pruefe(e);

    EXPECT_EQ(r.status, WacheStatus::Gruen) << "Ein nicht ausgechecktes Submodul darf die Wache NICHT rot "
                                            << "machen -- sonst waere sie auf jedem frischen Klon konstant "
                                            << "rot und damit wertlos.\n"
                                            << ergebnis_bericht(r);
    ASSERT_EQ(r.skips.size(), 1U) << "Der Verzicht MUSS protokolliert sein. Ein stiller Verzicht ist genau "
                                  << "die verdeckte Null, gegen die diese Wache gebaut ist.\n"
                                  << ergebnis_bericht(r);
    EXPECT_THAT(r.skips.front(), testing::HasSubstr("ext/alpha"));

    // T-4-GEGENEINGANG: die PAARUNG gilt weiter. Nimmt man die NOTICE-Zeile des
    // nicht ausgecheckten Submoduls heraus, wird es trotzdem rot.
    LizenzEingang ohne_zeile = e;
    ohne_zeile.notice_text =
        "Beispiel-NOTICE\n"
        "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
        "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
    const LizenzErgebnis r2 = pruefe(ohne_zeile);
    EXPECT_TRUE(hat_befund(r2, BefundArt::SubmodulOhneNoticeZeile))
        << "Nicht ausgecheckt heisst NUR: keine Inhaltspruefung. Die Paarung bleibt.\n"
        << ergebnis_bericht(r2);
}

// -----------------------------------------------------------------------------
// K12 -- DIE NENNER-PFLICHT. Drei Zustaende, die am echten Baum nicht
// herstellbar sind und in denen jede Forderung oben trivial erfuellt waere.
// Sie muessen ABBRUCH liefern -- ausdruecklich nicht Gruen und nicht Riss.
// -----------------------------------------------------------------------------
TEST(LizenzKern, NennerNullIstAbbruchNiemalsGruen) {
    {
        LizenzEingang e     = gesunder_satz();
        e.gitmodules_text   = "";
        e.notice_text       = "Beispiel-NOTICE\n"
                              "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_EQ(r.nenner_gitmodules, 0U);
        EXPECT_EQ(r.status, WacheStatus::Abbruch) << "0 .gitmodules-Eintraege: die Paarung waere leer.\n"
                                                  << ergebnis_bericht(r);
        EXPECT_TRUE(hat_befund(r, BefundArt::NennerNull)) << ergebnis_bericht(r);
    }
    {
        LizenzEingang e = gesunder_satz();
        e.vendor_am_baum.clear();
        e.notice_text =
            "Beispiel-NOTICE\n"
            "WACHE: SUBMODUL ext/alpha LIZENZ \"Alpha Public License\" DATEI LICENSE\n"
            "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_EQ(r.nenner_vendor, 0U);
        EXPECT_EQ(r.status, WacheStatus::Abbruch) << ergebnis_bericht(r);
    }
    {
        LizenzEingang e = gesunder_satz();
        e.spdx_funde.clear();
        const LizenzErgebnis r = pruefe(e);
        EXPECT_EQ(r.nenner_spdx, 0U);
        EXPECT_EQ(r.status, WacheStatus::Abbruch) << "0 gescannte SPDX-Dateien: die Uniformitaet waere "
                                                  << "trivial erfuellt.\n"
                                                  << ergebnis_bericht(r);
    }
}

// -----------------------------------------------------------------------------
// K13 -- DIE GRAMMATIK BINDET SICH SELBST: eine Eintragszeile ueber 120 Byte und
// eine Zeile, die WACHE: traegt, der Form aber nicht folgt, sind Befunde. Ohne
// den zweiten Fall koennte ein Tippfehler eine Zeile still verschwinden lassen.
// -----------------------------------------------------------------------------
TEST(LizenzKern, UnlesbareUndZuLangeEintragszeilenSindRot) {
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text += "WACHE: SUBMODUL ext/alpha LIZENZzz \"x\"\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::NoticeZeileUnlesbar))
            << "Eine WACHE:-Zeile, die der Grammatik nicht folgt, darf nicht stillschweigend "
            << "verworfen werden -- sonst verschwindet ein Eintrag durch einen Tippfehler.\n"
            << ergebnis_bericht(r);
    }
    {
        LizenzEingang e             = gesunder_satz();
        const std::string langer_pfad(90, 'x');
        e.notice_text += "WACHE: VENDOR " + langer_pfad + " LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::NoticeZeileZuLang)) << ergebnis_bericht(r);
    }
}

// -----------------------------------------------------------------------------
// K14 -- DIE ZWEI PARSER FUER SICH. Sie sind die Grundlage aller Faelle oben;
// ein stiller Parse-Fehler wuerde dort als "alles in Ordnung" erscheinen.
// -----------------------------------------------------------------------------
TEST(LizenzKern, ParseGitmodulesLiestGenauDiePathZeilen) {
    const std::string text =
        "[submodule \"a\"]\n"
        "\tpath = ext/a\n"
        "\turl = ../a.git\n"
        "\tpathologisch = nicht/das\n" // Gegeneingang: Praefix-Treffer darf NICHT zaehlen
        "# path = auskommentiert/zaehlt/trotzdem\n"
        "[submodule \"b\"]\n"
        "\tpath = ext/b\n";
    const std::vector<std::string> pfade = parse_gitmodules(text);
    // Die Raute ist in .gitmodules KEIN Kommentarzeichen fuer diesen Parser: er
    // liest, was git liest -- und dort beginnt ein Kommentar mit ';' oder '#' am
    // Zeilenanfang. Hier steht '#' am Anfang, die Zeile darf also NICHT zaehlen.
    EXPECT_THAT(pfade, testing::ElementsAre("ext/a", "ext/b"));
}

TEST(LizenzKern, ParseNoticeUnterscheidetDieDreiZeilenformen) {
    const std::string text =
        "Kopf ohne Marke\n"
        "WACHE: SUBMODUL p/eins LIZENZ \"M1\" DATEI LICENSE\n"
        "WACHE: SUBMODUL p/zwei KEINE-LIZENZDATEI\n"
        "WACHE: VENDOR p-drei LIZENZ \"M3\" DATEI klon/LICENSE\n";
    const auto e = parse_notice(text);
    ASSERT_EQ(e.size(), 3U);
    EXPECT_EQ(e[0].art, NoticeArt::Submodul);
    EXPECT_EQ(e[0].pfad, "p/eins");
    EXPECT_EQ(e[0].marker, "M1");
    EXPECT_EQ(e[0].lizenzdatei, "LICENSE");
    EXPECT_EQ(e[0].zeile, 2U);
    EXPECT_TRUE(e[0].wohlgeformt);
    EXPECT_EQ(e[1].art, NoticeArt::SubmodulOhneLizenzdatei);
    EXPECT_TRUE(e[1].wohlgeformt);
    EXPECT_EQ(e[2].art, NoticeArt::Vendor);
    EXPECT_EQ(e[2].marker, "M3");

    // GEGENEINGANG: SPALTE 0 BINDET. Eine EINGERUECKTE WACHE:-Zeile ist Text,
    // kein Eintrag -- sonst koennte die NOTICE ihre eigene Grammatik nicht
    // erklaeren, ohne die Muster-Zeilen mitzuzaehlen. Am Bautag 11.08. genau so
    // passiert: 6 statt 4 SUBMODUL- und 10 statt 9 VENDOR-Eintraege.
    const auto eingerueckt = parse_notice(
        "  WACHE: SUBMODUL <pfad> LIZENZ \"<marker>\" DATEI <relpfad>\n"
        "\tWACHE: VENDOR <pfad> KEINE-LIZENZDATEI\n"
        "WACHE: VENDOR echt LIZENZ \"M\" DATEI LICENSE\n");
    ASSERT_EQ(eingerueckt.size(), 1U) << "Eingerueckte WACHE:-Zeilen sind Text. Gezaehlt wurden "
                                      << eingerueckt.size() << " Eintrag/Eintraege statt 1.";
    EXPECT_EQ(eingerueckt[0].pfad, "echt");

    // GEGENEINGANG: ein LEERER Marker ist unlesbar, nicht "immer gefunden".
    const auto leer = parse_notice("WACHE: VENDOR p LIZENZ \"\" DATEI LICENSE\n");
    ASSERT_EQ(leer.size(), 1U);
    EXPECT_FALSE(leer[0].wohlgeformt) << "Ein leerer Marker stuende als Substring in JEDER Datei -- "
                                      << "er waere eine Zusicherung, die nie reissen kann.";
}

// =============================================================================
// TEIL 2 -- DER LAUF AM ECHTEN REPO
// =============================================================================

class LizenzAmObjekt : public ::testing::Test {
protected:
    static void SetUpTestSuite() {
        wurzel_  = std::filesystem::path(COMDARE_REPO_WURZEL_LIZENZ);
        eingang_ = new LizenzEingang(sammle_vom_baum(wurzel_));
    }
    static void TearDownTestSuite() {
        delete eingang_;
        eingang_ = nullptr;
    }
    static std::filesystem::path wurzel_;
    static LizenzEingang*        eingang_;
};

std::filesystem::path LizenzAmObjekt::wurzel_;
LizenzEingang*        LizenzAmObjekt::eingang_ = nullptr;

// -----------------------------------------------------------------------------
// O1 -- DIE NENNER ZUERST, UND ZWAR GEGEN EINE ZWEITE QUELLE (T-3/V-7).
// Der Prueflig zaehlt `path =`-Zeilen. Gegengezaehlt wird mit einem ANDEREN
// Textmerkmal derselben Datei ([submodule "-Koepfe) UND mit dem Dateisystem --
// jeder genannte Pfad muss dort als Verzeichnis existieren. Zwei Quellen, die
// nur uebereinstimmen koennen, wenn beide stimmen.
// -----------------------------------------------------------------------------
TEST_F(LizenzAmObjekt, NennerSindNichtNullUndDeckenSichMitZweiterQuelle) {
    ASSERT_FALSE(eingang_->gitmodules_text.empty())
        << "FAIL-CLOSED: .gitmodules unter " << wurzel_ << " ist leer oder fehlt.";

    const std::vector<std::string> pfade = parse_gitmodules(eingang_->gitmodules_text);

    // ZWEITE QUELLE 1: die Block-Koepfe, ein anderes Textmerkmal.
    std::size_t koepfe = 0;
    for (std::size_t i = eingang_->gitmodules_text.find("[submodule \""); i != std::string::npos;
         i             = eingang_->gitmodules_text.find("[submodule \"", i + 1)) {
        ++koepfe;
    }
    ASSERT_GT(koepfe, 0U) << "NENNER 0 aus der zweiten Quelle -- dann sagt der Abgleich nichts.";
    EXPECT_EQ(pfade.size(), koepfe) << "NENNER: " << pfade.size() << " path=-Zeilen gegen " << koepfe
                                    << " [submodule-Koepfe in .gitmodules.";

    // ZWEITE QUELLE 2: das Dateisystem. Der ASSERT auf die Zahl steht VOR der
    // Schleife -- eine Schleife ueber 0 Elemente ist immer gruen (T-3).
    ASSERT_GT(pfade.size(), 0U) << "NENNER 0 .gitmodules-Eintraege -- jede Paarung waere leer.";
    for (const std::string& p : pfade) {
        EXPECT_TRUE(std::filesystem::exists(wurzel_ / p))
            << "In .gitmodules steht '" << p << "', am Baum gibt es diesen Pfad nicht.";
    }

    ASSERT_GT(eingang_->vendor_am_baum.size(), 0U)
        << "NENNER 0 Vendor-Projekte unter Forschungsarbeiten/code -- die Vendor-Forderung waere leer.";
    ASSERT_GT(eingang_->spdx_funde.size(), 0U)
        << "NENNER 0 SPDX-Dateien unter Code/ -- die Uniformitaets-Forderung waere trivial erfuellt.";
}

// -----------------------------------------------------------------------------
// O2 -- DER GEGENSTAND: das echte Repo ist konsistent.
// Vor der Heilung ist dieser Fall ROT mit 'NOTICE fehlt an der Wurzel'; genau
// dieser Rot-Lauf ist der protokollierte Biss dieser Wache.
// -----------------------------------------------------------------------------
TEST_F(LizenzAmObjekt, EchtesRepoIstKonsistent) {
    const LizenzErgebnis r = pruefe(*eingang_);
    EXPECT_EQ(r.status, WacheStatus::Gruen) << ergebnis_bericht(r);
    EXPECT_EQ(r.befunde.size(), 0U) << ergebnis_bericht(r);
    // Die Nenner IN DIE AUSGABE, auch im gruenen Fall -- eine gruene Wache ohne
    // Nenner ist von einer leer laufenden nicht zu unterscheiden.
    std::cerr << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// O3 -- JEDES VENDOR-PROJEKT MIT LIZENZDATEI STEHT IN NOTICE. Der Nenner kommt
// vom Dateisystem, die Menge aus NOTICE -- zwei Quellen, und der ASSERT auf die
// Zahl steht vor der Schleife.
// -----------------------------------------------------------------------------
TEST_F(LizenzAmObjekt, JedesVendorProjektMitLizenzdateiStehtInNotice) {
    ASSERT_TRUE(eingang_->notice_vorhanden) << "Ohne NOTICE hat dieser Fall keinen Gegenstand.";
    const std::size_t am_baum = eingang_->vendor_am_baum.size();
    ASSERT_GT(am_baum, 0U) << "NENNER 0 -- die Schleife unten liefe leer und waere immer gruen.";

    std::size_t in_notice = 0;
    for (const auto& e : parse_notice(eingang_->notice_text)) {
        if (e.art == NoticeArt::Vendor) { ++in_notice; }
    }
    EXPECT_EQ(in_notice, am_baum) << "NENNER: " << am_baum << " Vendor-Projekt(e) mit Lizenzdatei am Baum "
                                  << "gegen " << in_notice << " WACHE: VENDOR-Zeile(n) in NOTICE.";
}

// -----------------------------------------------------------------------------
// O4 -- FAIL-CLOSED DES SAMMLERS. Ohne diesen Fall koennte ein falscher Pfad in
// COMDARE_REPO_WURZEL_LIZENZ als "alles in Ordnung" erscheinen: leerer Eingang,
// leere Mengen, keine Befunde.
// -----------------------------------------------------------------------------
TEST_F(LizenzAmObjekt, LeererBaumIstAbbruchUndNichtGruen) {
    const LizenzEingang  leer = sammle_vom_baum(std::filesystem::path("/nicht/vorhanden/repo"));
    const LizenzErgebnis r    = pruefe(leer);
    EXPECT_FALSE(leer.notice_vorhanden);
    EXPECT_EQ(r.status, WacheStatus::Abbruch) << "Ein leerer Baum muss ABBRUCH sein. Waere er Gruen, waere "
                                              << "ein Tippfehler im Define eine unsichtbar abgeschaltete "
                                              << "Wache.\n"
                                              << ergebnis_bericht(r);
}

} // namespace
