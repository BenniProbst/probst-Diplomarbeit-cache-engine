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
// NACHBESSERUNG 11.08. (Dual-Review, vier Blocker): die Wache war in
// erreichbaren Zustaenden IMMER GRUEN -- schlimmer als keine, weil sie falsches
// Vertrauen erzeugt. Die vier Loecher und ihre Faelle:
//   B-1 DATEI an nichts gebunden          -> K15 NoticeDarfNurEineWIRKLICHE...
//   B-2 Marker aus einem Leerzeichen      -> K16 MarkerOhneAussagekraftIstRot
//   B-3 "genau eine" nicht implementiert  -> K17 ZweiteZeileZumSelbenPfadIstRot
//   B-4 Skip-Liste abgeschrieben          -> K18 SkipListeKommtAusDerGitignore...
//   [7] Prosa ungeprueft                  -> K19 ProsazeilenVonNoticeUndLicense...
// Der jeweilige ROT-LAUF VOR DER HEILUNG steht literal im Kopf des Falls; die
// Koeder wurden aus /dev/urandom gewuerfelt, nicht aus dem Review abgeschrieben.
//
// TESTKRITIK (T-9), ausdruecklich statt verschwiegen:
//   * Der Lizenz-Marker ist eine SUBSTRING-PROBE, keine juristische
//     Textanalyse. Er faengt einen Lizenz-WECHSEL (der Titel aendert sich),
//     aber nicht jeden Versions-Wechsel innerhalb derselben Familie: die
//     Boilerplate-Texte von Apache und GPL tragen den Titel in Zeile 1 und die
//     Version erst in Zeile 2. GPLv3 -> GPLv2 liesse den Titel-Marker stehen.
//     Benannt, nicht geschlossen.
//   * Die AUSSAGEKRAFT-Probe ist eine UNTERGRENZE, kein Beweis: sie faengt den
//     Marker, der SELBST ein ueberall vorkommender Baustein ist, nicht den
//     seltenen, aber unkennzeichnenden.
//   * NICHT AUSGECHECKTE SUBMODULE werden nur GEPAART, nicht inhaltsgeprueft --
//     sonst waere die Wache auf jedem Klon ohne `git submodule update` konstant
//     rot (Doktrin: die Pipeline ist immer hart gruen). Am Objekt sind beide
//     Thesis-Einbindungen leer. Der Verzicht wird als SKIP protokolliert; der
//     Fall NichtAusgecheckesWirdNurGepaartUndProtokolliert friert beide Haelften
//     ein.
//   * Die Wache liest den ARBEITSBAUM, nicht die Historie -- und nicht den
//     INDEX. Eine ungetrackte Datei ausserhalb der Skip-Klassen zaehlt mit;
//     deshalb steht jede uebersprungene Klasse in der AUSGABE (Fall O5).
//   * Der SPDX-Scan liest je Datei nur den Kopf (4096 Byte).
//   * DIE EROSIONS-GRENZE DES SPDX-SCANS, am Objekt belegt (11.08.): eine
//     SPDX-Zeile zu ENTFERNEN statt zu wechseln laesst die Suite gruen -- die
//     Datei faellt still aus dem Zaehler, NennerNull greift erst bei 0. Die
//     Faelle hier decken die WECHSEL-Richtung; die WEGFALL-Richtung ist NICHT
//     gedeckt und waere eine SPDX-PFLICHT, also ein eigenes Paket: am Objekt
//     tragen 26 von 98 C++-Dateien unter Code/ (ohne external/ und ohne die
//     Bauverzeichnisse) ueberhaupt eine SPDX-Zeile. Sichtbar gemacht ist die
//     Erosion durch den Nenner NEBEN seiner Grundgesamtheit (Fall O5).
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
using comdare::ci_wachen::GitignoreMuster;
using comdare::ci_wachen::hat_befund;
using comdare::ci_wachen::LizenzEingang;
using comdare::ci_wachen::LizenzErgebnis;
using comdare::ci_wachen::marker_ist_aussagekraeftig;
using comdare::ci_wachen::NoticeArt;
using comdare::ci_wachen::parse_gitignore;
using comdare::ci_wachen::parse_gitmodules;
using comdare::ci_wachen::parse_notice;
using comdare::ci_wachen::passt_verzeichnismuster;
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
        {"ext/alpha", SubmodulAmBaum{true, {"LICENSE"}}},
        {"ext/beta", SubmodulAmBaum{true, {}}},
    };
    e.vendor_am_baum = {{"P99-Gamma", {"klon/LICENSE"}}};
    e.dateiinhalt    = {
        {"ext/alpha/LICENSE", "Alpha Public License\nAlle Rechte irgendwem.\n"},
        {"Forschungsarbeiten/code/P99-Gamma/klon/LICENSE", "Gamma License\nVersion 1.\n"},
    };
    e.spdx_funde = {SpdxFund{"Code/a.cpp", "Apache-2.0"}, SpdxFund{"Code/b.hpp", "Apache-2.0"}};
    // Die GRUNDGESAMTHEIT des SPDX-Zaehlers. Ein Zaehler ohne sie ist eine nackte
    // Zahl; 0 angefasste Dateien ist ausserdem ein ABBRUCH (Fall K12).
    e.spdx_gescannt = 7;
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
    EXPECT_EQ(r.nenner_code_dateien, 7U);
    EXPECT_EQ(r.nenner_notice_submodul, 2U);
    EXPECT_EQ(r.nenner_notice_vendor, 1U);
    EXPECT_EQ(r.skips.size(), 0U) << "Im gesunden Satz ist alles ausgecheckt -- kein SKIP erwartet.";
    // Der Nenner steht in der AUSGABE, nicht nur im Feld -- und mit seiner
    // Grundgesamtheit. "2" allein ist eine Zahl ohne Herkunft.
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("NENNER SPDX-Dateien          : 2 von 7 gescannten"));
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
    e.vendor_am_baum["P97-Neu"]            = {"LICENSE"};
    const LizenzErgebnis r                 = pruefe(e);

    EXPECT_TRUE(hat_befund(r, BefundArt::VendorProjektOhneNoticeZeile)) << ergebnis_bericht(r);
    EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("Vendor-Projekt ohne NOTICE-Zeile: P97-Neu"));
    EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// K10 -- KEINE-LIZENZDATEI BEHAUPTET, OBWOHL EINE DALIEGT.
// -----------------------------------------------------------------------------
TEST(LizenzKern, KeineLizenzdateiObwohlEineDaliegtIstRot) {
    LizenzEingang e                                = gesunder_satz();
    e.submodule_am_baum["ext/beta"].lizenzdateien  = {"COPYING"};
    const LizenzErgebnis r                         = pruefe(e);

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
    e.submodule_am_baum["ext/alpha"]       = SubmodulAmBaum{false, {}};
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
    {
        // Die GRUNDGESAMTHEIT selbst. Ein Zaehler von 2 ueber 0 angefassten
        // Dateien ist kein Ergebnis, sondern ein Widerspruch -- und am Baum ist
        // 0 angefasste Dateien genau der Zustand "falsche Wurzel".
        LizenzEingang e   = gesunder_satz();
        e.spdx_gescannt   = 0;
        const LizenzErgebnis r = pruefe(e);
        EXPECT_EQ(r.nenner_code_dateien, 0U);
        EXPECT_EQ(r.status, WacheStatus::Abbruch) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("keine einzige Datei angefasst"));
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
        EXPECT_TRUE(hat_befund(r, BefundArt::TextZeileZuLang)) << ergebnis_bericht(r);
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
// DIE VIER NACHGEBESSERTEN ZUSICHERUNGEN (Dual-Review 11.08.). Jede war am
// Objekt als HOHL nachgewiesen: die Wache war in erreichbaren Zustaenden IMMER
// gruen. Die Faelle unten sind die permanenten Koeder dieser vier Loecher.
// =============================================================================

// -----------------------------------------------------------------------------
// K15 -- DIE DATEI-BINDUNG (B-1). Zusicherung (2) sagte "der Marker steht in der
// DORT BENANNTEN Lizenzdatei" -- und band die DATEI an nichts.
//
// DER ROT-LAUF VOR DER HEILUNG, am echten Baum gefahren (11.08., Koeder aus
// /dev/urandom, R1=60f4f9ed74fb194d, Vendor-Index 1 von 9 gewuerfelt = P02-HOT):
// hot/LICENSE gegen "GNU GENERAL PUBLIC LICENSE" getauscht UND die NOTICE-Zeile
// auf eine Nicht-Lizenzdatei umgebogen, die den alten Marker traegt.
// Ausgabe der UNGEHEILTEN Wache: "LIZENZ-KONSISTENZ: GRUEN", "0 Befunde.",
// "[  PASSED  ] 4 tests." -- genau die Fehlerklasse KON2-25, gegen die die Wache
// gebaut ist, und sie ueberlebte sie.
// -----------------------------------------------------------------------------
TEST(LizenzKern, NoticeDarfNurEineWIRKLICHELizenzdateiBenennen) {
    // Vendor-Richtung.
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text =
            "Beispiel-NOTICE\n"
            "WACHE: SUBMODUL ext/alpha LIZENZ \"Alpha Public License\" DATEI LICENSE\n"
            "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
            "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/README.md\n";
        // Die benannte Datei EXISTIERT und traegt den Marker sogar -- sie ist nur
        // keine Lizenzdatei. Ohne die Bindung waere genau das gruen.
        e.dateiinhalt["Forschungsarbeiten/code/P99-Gamma/klon/README.md"] = "Gamma License steht hier im Fliesstext.\n";
        e.dateiinhalt["Forschungsarbeiten/code/P99-Gamma/klon/LICENSE"]   = "Delta License\nGanz andere Lizenz.\n";
        const LizenzErgebnis r = pruefe(e);

        EXPECT_TRUE(hat_befund(r, BefundArt::NoticeDateiIstKeineLizenzdatei)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("aber dort liegt als Lizenzdatei: klon/LICENSE"));
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
        EXPECT_FALSE(hat_befund(r, BefundArt::MarkerNichtInLizenzdatei))
            << "T-4-Gegeneingang: der Marker STEHT in der benannten Datei. Rot ist sie allein wegen der "
            << "DATEI-Bindung -- ein Test, der hier beide Befunde saehe, traefe die Zusicherung nicht.\n"
            << ergebnis_bericht(r);
    }
    // Submodul-Richtung. Sie ist NICHT dieselbe Codestelle, und am Objekt hat der
    // Reviewer genau hier "DATEI NOTICE" fuer die cache-engine durchbekommen --
    // ce/NOTICE behauptet Apache, ce/LICENSE daneben "Dual License".
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text =
            "Beispiel-NOTICE\n"
            "WACHE: SUBMODUL ext/alpha LIZENZ \"Alpha Public License\" DATEI NOTICE\n"
            "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
            "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
        e.dateiinhalt["ext/alpha/NOTICE"] = "Alpha Public License, behauptet das NOTICE.\n";
        const LizenzErgebnis r            = pruefe(e);

        EXPECT_TRUE(hat_befund(r, BefundArt::NoticeDateiIstKeineLizenzdatei)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("NOTICE nennt \"NOTICE\" als Lizenzdatei von ext/alpha"));
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
    }
    // T-4-GEGENEINGANG: eine Komponente mit MEHREREN Lizenzdateien. Die Bindung
    // fragt "ist es EINE davon", nicht "ist es die erste" -- sonst waere die
    // cache-engine (LICENSE + LICENSE_AUDIT_EXT.md) falsch rot.
    {
        LizenzEingang e                              = gesunder_satz();
        e.submodule_am_baum["ext/alpha"].lizenzdateien = {"COPYING", "LICENSE"};
        const LizenzErgebnis r                       = pruefe(e);
        EXPECT_EQ(r.status, WacheStatus::Gruen) << "LICENSE ist eine der beiden Lizenzdateien -- das ist "
                                                << "keine Abweichung.\n"
                                                << ergebnis_bericht(r);
    }
}

// -----------------------------------------------------------------------------
// K16 -- DER MARKER MUSS ETWAS ZUSICHERN (B-2). Der Vorbestand verwarf nur den
// LEEREN Marker; ein Marker aus EINEM LEERZEICHEN war wohlgeformt und stand als
// Substring in praktisch jeder Datei.
//
// DER ROT-LAUF VOR DER HEILUNG (11.08.): der Koeder wurde NICHT abgeschrieben,
// sondern gewuerfelt -- eine Zufallsposition (424 von 743 Byte) in der echten
// Lizenzdatei Forschungsarbeiten/code/P02-HOT/hot/LICENSE, das Zeichen dort war
// ein Leerzeichen. Ausgabe der UNGEHEILTEN Wache: "LIZENZ-KONSISTENZ: GRUEN",
// "0 Befunde.", "[  PASSED  ] 4 tests."
// -----------------------------------------------------------------------------
TEST(LizenzKern, MarkerOhneAussagekraftIstRot) {
    // (a) Der gewuerfelte Fall: ein Leerzeichen.
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text =
            "Beispiel-NOTICE\n"
            "WACHE: SUBMODUL ext/alpha LIZENZ \" \" DATEI LICENSE\n"
            "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
            "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::MarkerOhneAussagekraft)) << ergebnis_bericht(r);
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
        EXPECT_FALSE(hat_befund(r, BefundArt::MarkerNichtInLizenzdatei))
            << "Das Leerzeichen STEHT in der Datei. Genau deshalb ist es kein MarkerNichtInLizenzdatei, "
            << "sondern ein Marker, der nie reissen kann.\n"
            << ergebnis_bericht(r);
    }
    // (b) Der zweite Fall derselben Klasse: ein ueberall vorkommender Baustein.
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text =
            "Beispiel-NOTICE\n"
            "WACHE: SUBMODUL ext/alpha LIZENZ \"License\" DATEI LICENSE\n"
            "WACHE: SUBMODUL ext/beta KEINE-LIZENZDATEI\n"
            "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
        e.dateiinhalt["ext/alpha/LICENSE"] = "Irgendeine License steht hier.\n";
        const LizenzErgebnis r             = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::MarkerOhneAussagekraft)) << ergebnis_bericht(r);
    }
    // DAS ORAKEL DIREKT (T-5), beide Richtungen an EINER Stelle.
    EXPECT_FALSE(marker_ist_aussagekraeftig(" "));
    EXPECT_FALSE(marker_ist_aussagekraeftig("    "));
    EXPECT_FALSE(marker_ist_aussagekraeftig("\t"));
    EXPECT_FALSE(marker_ist_aussagekraeftig("x"));
    EXPECT_FALSE(marker_ist_aussagekraeftig("of"));
    EXPECT_FALSE(marker_ist_aussagekraeftig("the"));
    EXPECT_FALSE(marker_ist_aussagekraeftig("License"));
    EXPECT_FALSE(marker_ist_aussagekraeftig("Apache"));
    // Die nackte Versionsnummer. Sie kam beim ersten Lauf dieses Falles am 11.08.
    // DURCH -- der Fall hat die Luecke aufgedeckt, nicht ein Review.
    EXPECT_FALSE(marker_ist_aussagekraeftig("2.0"));
    EXPECT_FALSE(marker_ist_aussagekraeftig("3.0"));
    // T-4-GEGENEINGANG zur Versionsnummer: der ZUSAMMENGESETZTE Marker bleibt
    // zulaessig. Eine Schranke, die auch "Version 2.0" schnitte, waere zu grob.
    EXPECT_TRUE(marker_ist_aussagekraeftig("Version 2.0"));
    // T-4-GEGENEINGANG: die ELF Marker, die am Objekt wirklich in NOTICE stehen,
    // muessen ALLE durchkommen. Eine Untergrenze, die den Bestand schneidet,
    // waere keine Haertung, sondern ein Dauer-Rotstand.
    for (const char* echt : {"Comdare Cache Engine -- Dual License", "Apache License", "ISC License",
                             "an MIT license, plus a clause", "GNU GENERAL PUBLIC LICENSE", "MIT License",
                             "LGPL-2.1-or-later"}) {
        EXPECT_TRUE(marker_ist_aussagekraeftig(echt)) << "Marker am Objekt in Gebrauch: \"" << echt << "\"";
    }
}

// -----------------------------------------------------------------------------
// K17 -- GENAU EINE, NICHT MINDESTENS EINE (B-3). Zusicherung (1) sagt "genau
// eine WACHE:-Zeile je Pfad"; der Vorbestand benutzte beidseitig any_of/find.
//
// DER ROT-LAUF VOR DER HEILUNG (11.08.): die SUBMODUL-Zeile wurde nicht gewaehlt,
// sondern gewuerfelt (Index 3 von 4) und VERBATIM verdoppelt. Ausgabe der
// UNGEHEILTEN Wache: "LIZENZ-KONSISTENZ: GRUEN", "0 Befunde.",
// "NENNER NOTICE SUBMODUL-Zeilen: 5" gegen "NENNER .gitmodules-Eintraege: 4",
// "[  PASSED  ] 4 tests." -- zwei Zahlen, die auseinanderliefen, und nichts,
// das sie verglich.
// -----------------------------------------------------------------------------
TEST(LizenzKern, ZweiteZeileZumSelbenPfadIstRot) {
    // Submodul-Richtung, mit WIDERSPRUCH: derselbe Pfad, zwei Lizenzaussagen.
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text += "WACHE: SUBMODUL ext/alpha LIZENZ \"Zweitmeinung License\" DATEI LICENSE\n";
        e.dateiinhalt["ext/alpha/LICENSE"] = "Alpha Public License\nZweitmeinung License\n";
        const LizenzErgebnis r             = pruefe(e);

        EXPECT_TRUE(hat_befund(r, BefundArt::NoticeZeileMehrfach)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r),
                    testing::HasSubstr("NOTICE nennt denselben SUBMODUL-Pfad 2 mal, zugesichert ist GENAU EINE"));
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
        EXPECT_EQ(r.nenner_notice_submodul, 3U) << "Der Nenner selbst zeigt die Divergenz: 3 NOTICE-Zeilen "
                                                << "gegen 2 .gitmodules-Eintraege.\n"
                                                << ergebnis_bericht(r);
    }
    // Vendor-Richtung, VERBATIM verdoppelt -- der Fall, in dem nicht einmal ein
    // Widerspruch im Text steht und trotzdem eine Zeile zuviel dasteht.
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text += "WACHE: VENDOR P99-Gamma LIZENZ \"Gamma License\" DATEI klon/LICENSE\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::NoticeZeileMehrfach)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r),
                    testing::HasSubstr("NOTICE nennt denselben VENDOR-Pfad 2 mal, zugesichert ist GENAU EINE"));
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
    }
    // Die dritte Richtung: .gitmodules selbst nennt einen Pfad zweimal. Ohne sie
    // waere "genau eine" nur auf einer Seite der Paarung zugesichert.
    {
        LizenzEingang e = gesunder_satz();
        e.gitmodules_text += "[submodule \"ext/alpha-nochmal\"]\n\tpath = ext/alpha\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::GitmodulesPfadMehrfach)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr(".gitmodules nennt denselben Pfad 2 mal: ext/alpha"));
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
    }
    // T-4-GEGENEINGANG: der gesunde Satz hat je Pfad GENAU EINE Zeile und bleibt
    // gruen. Eine Multiplizitaets-Probe, die auch bei 1 anschlaegt, waere wertlos.
    EXPECT_FALSE(hat_befund(pruefe(gesunder_satz()), BefundArt::NoticeZeileMehrfach));
    EXPECT_FALSE(hat_befund(pruefe(gesunder_satz()), BefundArt::GitmodulesPfadMehrfach));
}

// -----------------------------------------------------------------------------
// K18 -- DIE SKIP-LISTE WIRD ABGELEITET, NICHT ABGESCHRIEBEN (B-4). Der Kopf
// behauptete, uebersprungen wuerden "genau die zwei Verzeichnisklassen, die
// .gitignore ohnehin ausschliesst" -- Code/.gitignore traegt VIER, und die CI
// baut nach Code/build-test und Code/build-test-debug.
//
// AM OBJEKT GEMESSEN (11.08., mit vorhandenem Code/build-test-debug): die
// UNGEHEILTE Wache meldete "NENNER SPDX-Dateien : 39" statt 26 -- 13 GENERIERTE
// Bauartefakte im Nenner. Der Koeder (R4=195e0856e54654ec) legte eine Datei mit
// "GPL-3.0-only" in ein Bauverzeichnis: die ungeheilte Wache wurde HART ROT
// ueber eine Datei, die es im Repo gar nicht gibt.
// -----------------------------------------------------------------------------
TEST(LizenzKern, SkipListeKommtAusDerGitignoreUndDecktDieCiBauverzeichnisse) {
    const GitignoreMuster m = parse_gitignore(
        "# Build\n"
        "build/\n"
        "build-*/\n"
        "cmake-build-*/\n"
        "_runs/\n"
        "\n"
        "# IDE\n"
        ".vscode/\n"
        "*.swp\n"       // Dateimuster: nicht Gegenstand, faellt still heraus
        "*.user\n"
        "Thumbs.db\n");
    EXPECT_THAT(m.verzeichnisse,
                testing::ElementsAre("build", "build-*", "cmake-build-*", "_runs", ".vscode"));
    EXPECT_EQ(m.unverstanden.size(), 0U) << "Diese fuenf Muster sind alle in der unterstuetzten Form.";

    // Die CI-Bauverzeichnisse, WOERTLICH aus .gitlab-ci.yml:1037 und :1082.
    EXPECT_TRUE(passt_verzeichnismuster("build-test", "build-*"));
    EXPECT_TRUE(passt_verzeichnismuster("build-test-debug", "build-*"));
    EXPECT_TRUE(passt_verzeichnismuster("build", "build"));
    EXPECT_TRUE(passt_verzeichnismuster("cmake-build-debug", "cmake-build-*"));
    EXPECT_TRUE(passt_verzeichnismuster("_runs", "_runs"));
    // T-4-GEGENEINGANG: das Muster darf NICHT alles fressen. `grep -v /build`
    // frisst `/builder/` -- dieselbe Klasse Fehler, hier ausdruecklich verboten.
    EXPECT_FALSE(passt_verzeichnismuster("builder", "build"));
    EXPECT_FALSE(passt_verzeichnismuster("ci_wachen", "build-*"));
    EXPECT_FALSE(passt_verzeichnismuster("build", "build-*")) << "'build' hat keinen Bindestrich.";
    // DAS NACKTE "*". Es traefe JEDES Verzeichnis und liesse den SPDX-Scan mit 0
    // Dateien enden -- die verdeckte Null in Reinform. Dieser Fall hat es beim
    // ersten Lauf am 11.08. aufgedeckt: die Funktion lieferte true.
    EXPECT_FALSE(passt_verzeichnismuster("tests", "*"));
    EXPECT_FALSE(passt_verzeichnismuster("", "*"));

    // Ein Muster, das die unterstuetzte Form VERFEHLT, wird protokolliert statt
    // stillschweigend verworfen -- sonst waere die Skip-Luecke unsichtbar.
    const GitignoreMuster schwer = parse_gitignore("!wichtig/\ntief/drin/\nvor*mitte*/\n*/\n");
    EXPECT_EQ(schwer.verzeichnisse.size(), 0U);
    EXPECT_THAT(schwer.unverstanden, testing::ElementsAre("!wichtig", "tief/drin", "vor*mitte*", "*"));
}

// -----------------------------------------------------------------------------
// K19 -- DIE ZEILENNORM VON NOTICE UND LICENSE (Blocker 7 des Reviews).
// KEIN Werkzeug prueft die Prosa dieser beiden Dateien: die Diff-Hygiene-Wache
// ueberspringt LICENSE und NOTICE namentlich, und die Lizenz-Wache prueft die
// Laenge bisher nur fuer WACHE:-Zeilen und ASCII gar nicht.
//
// AM OBJEKT GEMESSEN (11.08.): eine Prosazeile mit Umlauten UND eine 152-Byte-
// Prosazeile an NOTICE angehaengt -> die UNGEHEILTE Wache blieb "GRUEN",
// "0 Befunde.", "[  PASSED  ] 1 test."
// -----------------------------------------------------------------------------
TEST(LizenzKern, ProsazeilenVonNoticeUndLicenseHaltenAsciiUndLaenge) {
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text += "Eine Prosazeile mit einem Umlaut: \xc3\xa4\n"; // UTF-8 'ae'
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::TextZeileNichtAscii)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("NOTICE-Zeile 5 traegt Byte 0xC3"));
        EXPECT_EQ(r.status, WacheStatus::Riss) << ergebnis_bericht(r);
    }
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text += "Prosa " + std::string(130, 'x') + "\n"; // keine WACHE:-Zeile
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::TextZeileZuLang))
            << "Der Vorbestand pruefte die Laenge NUR fuer WACHE:-Zeilen -- Prosa lief durch.\n"
            << ergebnis_bericht(r);
    }
    {
        // Die Wurzel-LICENSE ist derselbe Gegenstand und wird von derselben
        // Funktion geprueft. Zwei Abschriften waeren eine Gelegenheit zur Divergenz.
        LizenzEingang e = gesunder_satz();
        e.license_text += "Eine Klausel mit einem Gedankenstrich: \xe2\x80\x94\n";
        const LizenzErgebnis r = pruefe(e);
        EXPECT_TRUE(hat_befund(r, BefundArt::TextZeileNichtAscii)) << ergebnis_bericht(r);
        EXPECT_THAT(ergebnis_bericht(r), testing::HasSubstr("LICENSE-Zeile 5 traegt Byte 0xE2"));
    }
    // T-4-GEGENEINGANG: der gesunde Satz ist ASCII und kurz -- und bleibt gruen.
    // Eine Norm-Probe, die auch sauberen Text rot macht, waere wertlos.
    EXPECT_FALSE(hat_befund(pruefe(gesunder_satz()), BefundArt::TextZeileNichtAscii));
    EXPECT_FALSE(hat_befund(pruefe(gesunder_satz()), BefundArt::TextZeileZuLang));
    // Und der Tabulator bleibt erlaubt: er steht in .gitmodules-artiger Einrueckung.
    {
        LizenzEingang e = gesunder_satz();
        e.notice_text += "\tEingerueckte Prosa mit Tabulator.\n";
        EXPECT_FALSE(hat_befund(pruefe(e), BefundArt::TextZeileNichtAscii));
    }
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

// -----------------------------------------------------------------------------
// O5 -- DER SPDX-NENNER IST UMGEBUNGSABHAENGIG, UND SEINE HERKUNFT STEHT IN DER
// AUSGABE. Das ist die eigentliche Heilung von B-4: die Zahl bleibt
// umgebungsabhaengig (sie MUSS es sein, sie zaehlt Dateien am Baum), aber jedes
// ausgelassene Verzeichnis wird beim Namen genannt, und der Zaehler steht neben
// seiner Grundgesamtheit.
//
// DIESER FALL LAEUFT IM CI-KONTEXT: test:unit baut nach Code/build-test,
// test:unit:debug nach Code/build-test-debug (.gitlab-ci.yml:1037/:1082) und
// faehrt DANACH make check -- das Bauverzeichnis existiert also, waehrend dieser
// Test laeuft. Er ist damit kein Laborfall, sondern der Normalfall.
// -----------------------------------------------------------------------------
TEST_F(LizenzAmObjekt, SpdxNennerNenntSeineGrundgesamtheitUndJedenUebersprungenenPfad) {
    ASSERT_GT(eingang_->spdx_gescannt, 0U) << "FAIL-CLOSED: der SPDX-Scan hat unter " << wurzel_
                                           << "/Code keine einzige Datei angefasst.";
    EXPECT_LE(eingang_->spdx_funde.size(), eingang_->spdx_gescannt)
        << "NENNER: " << eingang_->spdx_funde.size() << " SPDX-tragende von " << eingang_->spdx_gescannt
        << " gescannten Dateien -- der Zaehler kann seine Grundgesamtheit nicht ueberschreiten.";

    // Code/external/ MUSS in der Skip-Liste stehen: Fremdcode ist nicht
    // Gegenstand der SPDX-Uniformitaet, und es ist der einzige fest verdrahtete Skip.
    EXPECT_THAT(eingang_->spdx_uebersprungen, testing::Contains("Code/external"));

    // KEINE Fundstelle darf aus einem uebersprungenen Verzeichnis stammen. Das ist
    // die eigentliche Aussage -- ohne sie waere "es steht in der Skip-Liste" nur
    // eine Behauptung ueber eine Liste, nicht ueber den Nenner.
    for (const auto& fund : eingang_->spdx_funde) {
        for (const std::string& weg : eingang_->spdx_uebersprungen) {
            EXPECT_FALSE(fund.datei.rfind(weg + "/", 0) == 0)
                << "Die Datei " << fund.datei << " liegt unter dem uebersprungenen " << weg
                << " und ist trotzdem im Nenner.";
        }
    }

    // Kein .gitignore-Verzeichnismuster darf unausgewertet bleiben. Traegt
    // Code/.gitignore je ein Muster in einer Form, die der Sammler nicht kennt,
    // reisst dieser Fall -- statt dass die Luecke still entsteht.
    EXPECT_THAT(eingang_->gitignore_unverstanden, testing::IsEmpty())
        << "Code/.gitignore traegt ein Verzeichnismuster, das der Skip nicht auswerten kann.";

    // Die Zahlen IN DIE AUSGABE -- auch im gruenen Fall.
    const LizenzErgebnis r = pruefe(*eingang_);
    std::cerr << "O5 NENNER SPDX: " << r.nenner_spdx << " von " << r.nenner_code_dateien
              << " gescannten Dateien unter Code/, " << eingang_->spdx_uebersprungen.size()
              << " Verzeichnis(se) uebersprungen.\n"
              << ergebnis_bericht(r);
}

// -----------------------------------------------------------------------------
// O6 -- JEDER MARKER UND JEDE DATEI-ANGABE DER ECHTEN NOTICE HAELT DIE ZWEI NEUEN
// SCHRANKEN. Der Nenner kommt aus der NOTICE selbst, und der ASSERT auf die Zahl
// steht VOR der Schleife -- eine Schleife ueber 0 Eintraege ist immer gruen.
// -----------------------------------------------------------------------------
TEST_F(LizenzAmObjekt, JederMarkerDerEchtenNoticeTraegtAussagekraft) {
    ASSERT_TRUE(eingang_->notice_vorhanden) << "Ohne NOTICE hat dieser Fall keinen Gegenstand.";
    const auto eintraege = parse_notice(eingang_->notice_text);

    std::size_t mit_marker = 0;
    for (const auto& e : eintraege) {
        if (!e.wohlgeformt || e.marker.empty()) { continue; }
        ++mit_marker;
    }
    ASSERT_GT(mit_marker, 0U) << "NENNER 0 Marker -- die Schleife unten liefe leer und waere immer gruen.";
    std::cerr << "O6 NENNER: " << mit_marker << " Marker von " << eintraege.size() << " WACHE:-Zeilen.\n";

    for (const auto& e : eintraege) {
        if (!e.wohlgeformt || e.marker.empty()) { continue; }
        EXPECT_TRUE(marker_ist_aussagekraeftig(e.marker))
            << "NOTICE-Zeile " << e.zeile << " traegt den Marker \"" << e.marker
            << "\" -- er faellt unter die Untergrenze der Aussagekraft.";
    }
}

} // namespace
