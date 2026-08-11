// test_ci_wache_guard_basis.cpp -- steht die Basis der Diff-Hygiene-Wache im       (2026-08-10)
// versionierten Text, oder in einer GitLab-Web-Einstellung?
// =============================================================================
// DER BEFUND, DER DIESE WACHE AUSLOEST (am Objekt gemessen, 10.08.2026):
//
// `.gitlab-ci.yml` setzte im Job lint:diff-hygiene
//         COMDARE_GUARD_BASIS_REF: "origin/$CI_DEFAULT_BRANCH"
// $CI_DEFAULT_BRANCH ist KEINE Repo-Groesse, sondern das Feld default_branch der
// GitLab-Projekteinstellungen. Fuer Projekt 288 steht es auf 'development'
// (Rohbeleg im Baum: docs/sessions/backups/20260802-e23-suchlauf-belege/e23/
// projects_all.ndjson, Zeile id=288 -- zum Vergleich id=286 = 'main').
//
// ZWEI FOLGEN, beide gemessen an ce/super-Stand d8f3cd77:
//
//   (1) WER DAS FELD IM WEB UMSTELLT, VERSCHIEBT DIE BASIS DIESER WACHE -- ohne
//       Commit, ohne Diff, ohne Review. Es gaebe kein Signal.
//   (2) SCHWERER: mit 'development' war die Wache auf jeder development-Pipeline
//       ein NO-OP. merge-base(origin/development, HEAD) = HEAD, also
//       "BEREICHSBREITE: 0 Commit(s)", "0 Zeilen geprueft", GRUEN. Mit origin/main
//       sind es am selben Stand 52 Commit(s), 60 Datei(en), 7007 Zeilen im Scope.
//
// WAS DIESE DATEI ZUSICHERT -- und was NICHT:
//   ZUSICHERT: die Basis steht LITERAL in der .gitlab-ci.yml, sie traegt keine
//              Variablen-Interpolation, sie nennt origin/main, und der Job holt
//              den genannten Zweig VOR dem Aufruf der Wache (sonst haelt das
//              Literal nicht -- s. Fall HoltDenBasisZweigSelbst).
//   NICHT:     sie prueft nicht, was default_branch bei GitLab HEUTE ist. Das ist
//              genau der Punkt: nach dieser Umstellung ist es der Wache egal.
//              Sie prueft auch nicht das ce (das haelt seine Basis in
//              COMDARE_HYG_FF_BASIS mit Literal-Default 'main', eigene Pipeline).
//
// TESTKRITIK (T-9): strenger Zeilen-Scanner, kein YAML-Parser -- wie die
// Schwester-Wachen test_ci_wache_registrierung.cpp und
// test_ci_wache_speicherbudget.cpp. YAML-Anker, `extends` und `include` sieht er
// nicht; ein Job, der COMDARE_GUARD_BASIS_REF anderswo UEBERSCHREIBT, ist damit
// nicht erfasst. Die Gegenprobe dazu steht als eigener Fall
// (KeineZweiteZuweisungImGanzenText).
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <cstddef>
#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/ci_yml_scanner.hpp"

namespace {

using comdare::ci_wachen::finde_job_block;
using comdare::ci_wachen::ist_kommentarzeile;
using comdare::ci_wachen::lies_zeilen;
using comdare::ci_wachen::zaehle_roh;
using comdare::ci_wachen::zaehle_wirksam;

// Der Job, dessen Basis hier festgehalten wird, und der Schluessel darin.
// Der Doppelpunkt gehoert DAZU: finde_job_block vergleicht die Kopfzeile exakt
// (`zeile == jobname`), nicht als Praefix -- ohne ihn liefert es nullopt.
constexpr std::string_view kJobName    = "lint:diff-hygiene:";
constexpr std::string_view kSchluessel = "COMDARE_GUARD_BASIS_REF:";

// Die geforderte Basis. Sie steht hier UND in der .gitlab-ci.yml; genau das Paar
// haelt der Fall NenntGenauDieVereinbarteBasis zusammen. Wer sie aendern will,
// aendert beide Stellen -- und sieht dabei die Begruendung im Kopf des Jobs.
constexpr std::string_view kBasisSoll = "origin/main";

// Der Aufruf der Wache; der Vorspann MUSS davor stehen, nicht irgendwo im Job.
constexpr std::string_view kWacheAufruf = "sh scripts/ci_diff_ascii_width_guard.sh --seit-basis";

// Liest die Zeilen der .gitlab-ci.yml oder laesst den Fall fail-closed scheitern.
std::vector<std::string> yml_zeilen_oder_fail() {
    auto zeilen = lies_zeilen(std::filesystem::path(COMDARE_CI_YML_PFAD));
    EXPECT_TRUE(zeilen.has_value()) << "FAIL-CLOSED: .gitlab-ci.yml nicht lesbar unter " << COMDARE_CI_YML_PFAD;
    if (!zeilen.has_value()) {
        return {};
    }
    EXPECT_GT(zeilen->size(), 0U) << "FAIL-CLOSED: .gitlab-ci.yml ist leer -- jede Forderung waere trivial erfuellt.";
    return *zeilen;
}

// Der Wert hinter kSchluessel in einer Zeile, ohne Anfuehrungszeichen und Rand.
std::string wert_von(const std::string& zeile) {
    const std::size_t pos = zeile.find(kSchluessel);
    if (pos == std::string::npos) {
        return {};
    }
    std::string wert = zeile.substr(pos + kSchluessel.size());
    // Zeilenendkommentar abschneiden -- andere Zeilen dieser Datei tragen welche.
    const std::size_t raute = wert.find('#');
    if (raute != std::string::npos) {
        wert = wert.substr(0, raute);
    }
    const std::size_t a = wert.find_first_not_of(" \t\"'");
    if (a == std::string::npos) {
        return {};
    }
    const std::size_t b = wert.find_last_not_of(" \t\"'\r");
    return wert.substr(a, b - a + 1);
}

// Alle WIRKSAMEN (nicht auskommentierten) Zuweisungen des Schluessels im Block.
std::vector<std::string> zuweisungen(const std::vector<std::string>& zeilen) {
    std::vector<std::string> gefunden;
    for (const auto& zeile : zeilen) {
        if (ist_kommentarzeile(zeile)) {
            continue;
        }
        if (zeile.find(kSchluessel) != std::string::npos) {
            gefunden.push_back(zeile);
        }
    }
    return gefunden;
}

class GuardBasis : public ::testing::Test {
  protected:
    void SetUp() override {
        zeilen_ = yml_zeilen_oder_fail();
        if (zeilen_.empty()) {
            return;
        }
        block_ = finde_job_block(zeilen_, std::string(kJobName));
        ASSERT_TRUE(block_.has_value()) << "Job-Block '" << kJobName << "' fehlt in .gitlab-ci.yml. "
                                        << "Ohne ihn hat diese Wache keinen Gegenstand -- kein stilles Gruen.";
    }

    std::vector<std::string>              zeilen_;
    std::optional<comdare::ci_wachen::JobBlock> block_;
};

// -----------------------------------------------------------------------------
// R1 -- DER NENNER ZUERST. Genau EINE wirksame Zuweisung im Job.
// -----------------------------------------------------------------------------
TEST_F(GuardBasis, GenauEineWirksameZuweisungImJobBlock) {
    const auto treffer = zuweisungen(block_->zeilen);
    EXPECT_EQ(treffer.size(), 1U) << "NENNER: " << treffer.size() << " wirksame Zuweisung(en) von "
                                  << kSchluessel << " im Block '" << kJobName << "' (gefordert: genau 1). "
                                  << "Bei 0 misst die Wache gegen die Kandidaten-Kette statt gegen die "
                                  << "vereinbarte Basis; bei mehr als 1 entscheidet die Reihenfolge.";
}

// -----------------------------------------------------------------------------
// R2 -- DER KERN: LITERAL, KEINE INTERPOLATION.
// -----------------------------------------------------------------------------
TEST_F(GuardBasis, BasisIstLiteralUndTraegtKeineVariable) {
    const auto treffer = zuweisungen(block_->zeilen);
    ASSERT_EQ(treffer.size(), 1U) << "Vorbedingung aus R1 verletzt -- dieser Fall waere sonst mehrdeutig.";

    const std::string wert = wert_von(treffer.front());
    ASSERT_FALSE(wert.empty()) << "Der Wert hinter " << kSchluessel << " ist leer. Die Wache faellt dann auf "
                               << "ihre Kandidaten-Kette zurueck -- das ist keine vereinbarte Basis.";

    EXPECT_EQ(wert.find('$'), std::string::npos)
        << "Die Basis lautet '" << wert << "' und traegt eine Variablen-Interpolation. "
        << "Damit steht sie NICHT im versionierten Text: $CI_DEFAULT_BRANCH ist das Feld default_branch "
        << "der GitLab-Projekteinstellungen und laesst sich im Web umstellen -- ohne Commit, ohne Diff, "
        << "ohne Signal. Gemessen 10.08.2026: mit 'development' als Basis war diese Wache auf jeder "
        << "development-Pipeline ein NO-OP (0 Commit(s) im Bereich, 0 Zeilen geprueft, GRUEN).";
}

// -----------------------------------------------------------------------------
// R3 -- SIE NENNT DIE VEREINBARTE BASIS, nicht irgendein Literal.
// -----------------------------------------------------------------------------
TEST_F(GuardBasis, NenntGenauDieVereinbarteBasis) {
    const auto treffer = zuweisungen(block_->zeilen);
    ASSERT_EQ(treffer.size(), 1U);
    EXPECT_EQ(wert_von(treffer.front()), std::string(kBasisSoll))
        << "Die Basis soll '" << kBasisSoll << "' sein: main ist die Autoritaet (Gitflow), development "
        << "laeuft voraus, und main..HEAD enthaelt development..HEAD. Wer das aendert, aendert auch "
        << "kBasisSoll in dieser Datei -- und liest dabei die Begruendung im Kopf des Jobs.";
}

// -----------------------------------------------------------------------------
// R4 -- DAS LITERAL HAELT NUR MIT DEM VORSPANN.
// Gemessen 10.08.2026, gleicher Baum, gleicher Koeder, einziger Unterschied
// "gibt es refs/remotes/origin/main":
//     vorhanden -> Basis origin/main,        2 Commit(s), 1 Nicht-ASCII, rc=1 ROT
//     fehlt     -> Basis origin/development, 0 Commit(s), 0 geprueft,    rc=0 GRUEN
// Die Wache bricht seit 10.08. in diesem Fall selbst ab; der Vorspann sorgt dafuer,
// dass es gar nicht erst dazu kommt. Beide Haelften werden hier festgehalten.
// -----------------------------------------------------------------------------
TEST_F(GuardBasis, HoltDenBasisZweigSelbstUndZwarVORDemAufruf) {
    const auto& job = block_->zeilen;
    // In zwei Stuecken geschrieben, damit die Zeile unter 120 Byte bleibt -- die
    // Diff-Hygiene-Wache, um die es hier geht, hat genau diese Zeile beanstandet.
    static constexpr std::string_view kFetchTeilA = "git fetch --no-tags origin \"+refs/heads/${_sup_zweig}";
    static constexpr std::string_view kFetchTeilB = ":refs/remotes/origin/${_sup_zweig}\"";
    const std::string                 fetch_soll  = std::string(kFetchTeilA) + std::string(kFetchTeilB);

    const std::size_t n_fetch = zaehle_wirksam(job, fetch_soll);
    EXPECT_EQ(n_fetch, 1U) << "NENNER: " << n_fetch << " Fetch-Zeile(n) fuer den Basis-Zweig im Block '"
                           << kJobName << "' (gefordert: genau 1). Ohne sie kann origin/main im Job-Klon "
                           << "fehlen -- und dann entscheidet nicht mehr der versionierte Text.";

    // Reihenfolge: der Fetch MUSS vor dem Aufruf der Wache stehen.
    std::size_t i_fetch = job.size();
    std::size_t i_wache = job.size();
    for (std::size_t i = 0; i < job.size(); ++i) {
        if (ist_kommentarzeile(job[i])) {
            continue;
        }
        if (i_fetch == job.size() && job[i].find("refs/remotes/origin/${_sup_zweig}") != std::string::npos) {
            i_fetch = i;
        }
        if (i_wache == job.size() && job[i].find(kWacheAufruf) != std::string::npos) {
            i_wache = i;
        }
    }
    ASSERT_LT(i_wache, job.size()) << "Der Aufruf '" << kWacheAufruf << "' steht nicht im Block '" << kJobName
                                   << "'. Ein Job ohne Aufruf ist keine Wache.";
    ASSERT_LT(i_fetch, job.size()) << "Keine Fetch-Zeile gefunden -- s. den Nenner oben.";
    EXPECT_LT(i_fetch, i_wache) << "Der Fetch steht in Zeile " << i_fetch << " des Blocks, der Aufruf in "
                                << i_wache << ". Ein Fetch NACH dem Aufruf kommt zu spaet.";
}

// -----------------------------------------------------------------------------
// R5 -- GEGENPROBE ZUM SCANNER: keine ZWEITE Zuweisung irgendwo im ganzen Text.
// Der Block-Scanner sieht `extends` und Anker nicht; diese Gegenprobe faengt
// wenigstens die direkte Ueberschreibung in einem anderen Job.
// -----------------------------------------------------------------------------
TEST_F(GuardBasis, KeineZweiteZuweisungImGanzenText) {
    const std::size_t wirksam = zaehle_wirksam(zeilen_, kSchluessel);
    const std::size_t roh     = zaehle_roh(zeilen_, kSchluessel);
    EXPECT_EQ(wirksam, 1U) << "NENNER: " << wirksam << " wirksame und " << roh
                           << " rohe Vorkommen von " << kSchluessel << " in der ganzen Datei "
                           << "(gefordert wirksam: genau 1). Eine zweite Zuweisung macht die Basis "
                           << "von der Job-Reihenfolge abhaengig.";
    EXPECT_GE(roh, wirksam) << "roh < wirksam ist unmoeglich -- der Scanner selbst ist defekt.";
}

// -----------------------------------------------------------------------------
// R6 -- FAIL-CLOSED DES LESERS. "Datei weg" darf nicht wie "alles in Ordnung"
// aussehen. Ohne diesen Fall waere jede Forderung oben an einem leeren Vektor
// trivial erfuellt.
// -----------------------------------------------------------------------------
TEST_F(GuardBasis, FehlendeDateiLiefertNulloptUndKeineLeereListe) {
    const auto weg = lies_zeilen(std::filesystem::path("/nicht/vorhanden/.gitlab-ci.yml"));
    EXPECT_FALSE(weg.has_value()) << "Eine fehlende Datei muss nullopt liefern, nie eine leere Liste: "
                                  << "sonst haetten 'Datei weg' und 'Datei leer' denselben Wert.";
}

} // namespace
