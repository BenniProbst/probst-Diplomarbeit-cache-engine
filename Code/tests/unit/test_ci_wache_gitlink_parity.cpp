// test_ci_wache_gitlink_parity.cpp -- die Thesis-Gitlink-Paritaets-Wache als Pruefling.
//                                                                        (2026-08-09)
// =============================================================================
// LOEST AB (nicht: loescht): ci/tests/thesis_gitlink_parity_probe.sh (698 Zeilen,
// F1-F13, M1-M5). Die Datei bleibt im Baum und traegt einen Verweis hierher.
//
// DIE KOLLISION, DIE HIER VERSCHWINDET -- 28 Kopfzeilen Messprotokoll der abgeloesten
// Probe drehten sich um genau diesen einen Punkt:
//   In der rc-Domaene lieferten "ein Gitlink fehlt" und "die Zeiger divergieren" BEIDE
//   rc=1. Ein Mutant ohne den fail-closed-Zweig fiel deshalb eine Handvoll Zeilen
//   spaeter im Divergenz-Zweig. Gemessen:
//       Eingang "nur der lebende Pfad":  ORIG 1 -> MUTANT 1   (KEIN Unterschied)
//       Eingang "BEIDE fehlen":          ORIG 1 -> MUTANT 0   (Unterschied)
//   Nur wenn BEIDE fehlten, waren beide Zeiger gleich (beide leer), der Divergenz-Zweig
//   griff nicht mehr, und der Mutant meldete "Paritaet OK ... beide Zeiger auf " mit
//   LEEREM SHA und rc=0. GENAU EIN Fall (F6) konnte ihn toeten -- ohne ihn haetten F4
//   und F5 eine Deckung nur vorgetaeuscht.
//
//   HIER SIND ES ZWEI WERTE. Der Fall mit EINEM fehlenden Gitlink toetet den Mutanten
//   jetzt ebenfalls, weil ParityRissArt::GitlinkFehlt != ParityRissArt::Divergenz --
//   nicht erst, wenn zufaellig auch der Exit-Code abweicht. Der Fall "beide fehlen"
//   bleibt trotzdem in der Tabelle: er ist der schaerfste, nicht mehr der einzige.
//
// WAS DIE ABGELOESTE PROBE ALS UNGEDECKT MELDEN MUSSTE UND HIER GEDECKT IST:
//   * "die richtige --quelle je Aufrufstelle": jetzt in test_ci_wache_registrierung.cpp
//     ueber den ci_yml_scanner geprueft (verify:submodules head, anhang:forward index).
//   * "git/awk nicht gefunden": beide Zweige waren ohne Selbstverstuemmelung nicht
//     erreichbar (ein PATH ohne git nimmt der Probe das Werkzeug, mit dem sie ihre
//     Fixtures baut). Ueber die Naht sind es gewoehnliche Faelle.
//   * "eine Aufweichung, die den Feldvergleich verdreht (160000 -> 100644)": die beiden
//     Feld-Parser sind reine Funktionen und werden mit missgestalteten Zeilen gefahren,
//     die es an echtem git gar nicht gibt.
//
// ORAKEL (T-5 / K13): die SHAs sind keine abgeschriebenen Konstanten, sondern je Lauf
// frisch gewuerfelt und WOERTLICH aus dem Protokoll zurueckgefordert. Eine Wache, die
// einen festen Wert faelscht oder die Zeiger verwechselt, faellt daran.
//
// ASCII-only, Zeilen <= 120 Byte.
// =============================================================================

#include <filesystem>
#include <optional>
#include <set>
#include <string>
#include <vector>

#include <gmock/gmock.h>
#include <gtest/gtest-spi.h>
#include <gtest/gtest.h>

#include "comdare/ci_wachen/ergebnis.hpp"
#include "comdare/ci_wachen/git_quelle.hpp"
#include "comdare/ci_wachen/gitlink_parity.hpp"
#include "comdare/ci_wachen/prozess.hpp"
#include "comdare/ci_wachen/werkbank.hpp"

using comdare::ci_wachen::EchteGitQuelle;
using comdare::ci_wachen::exit_code;
using comdare::ci_wachen::GitlinkAntwort;
using comdare::ci_wachen::GitlinkQuelle;
using comdare::ci_wachen::ParityAbbruchGrund;
using comdare::ci_wachen::ParityArgumente;
using comdare::ci_wachen::ParityErgebnis;
using comdare::ci_wachen::ParityRissArt;
using comdare::ci_wachen::parse_ls_files_stage_zeile;
using comdare::ci_wachen::parse_ls_tree_zeile;
using comdare::ci_wachen::parse_parity_argumente;
using comdare::ci_wachen::PFAD_LEBEND;
using comdare::ci_wachen::PFAD_TOT;
using comdare::ci_wachen::pruefe_gitlink_paritaet;
using comdare::ci_wachen::ProzessArt;
using comdare::ci_wachen::ProzessAuftrag;
using comdare::ci_wachen::ProzessAusgang;
using comdare::ci_wachen::WacheStatus;
using comdare::ci_wachen::werkbank::FakeGitQuelle;
using comdare::ci_wachen::werkbank::FixtureRepo;
using comdare::ci_wachen::werkbank::Wuerfel;
using testing::HasSubstr;

namespace {

// ---- Forderungs-Helfer: JEDER erzeugt GENAU EINE Assertion (spi-Vorbedingung) ------
void fordere_status(const ParityErgebnis& ist, WacheStatus soll) {
    EXPECT_EQ(ist.status, soll) << "Protokoll:\n" << ist.protokoll();
}
void fordere_riss(const ParityErgebnis& ist, ParityRissArt soll) {
    EXPECT_EQ(ist.riss, std::optional<ParityRissArt>{soll}) << "Protokoll:\n" << ist.protokoll();
}
void fordere_kein_riss(const ParityErgebnis& ist) {
    EXPECT_EQ(ist.riss, std::optional<ParityRissArt>{}) << "Protokoll:\n" << ist.protokoll();
}
void fordere_abbruch(const ParityErgebnis& ist, ParityAbbruchGrund soll) {
    EXPECT_EQ(ist.abbruch, std::optional<ParityAbbruchGrund>{soll}) << "Protokoll:\n" << ist.protokoll();
}
void fordere_nenner(const ParityErgebnis& ist, int soll) {
    EXPECT_EQ(ist.nenner, soll) << "Protokoll:\n" << ist.protokoll();
}
void fordere_fehlende(const ParityErgebnis& ist, const std::vector<std::string>& soll) {
    EXPECT_EQ(ist.fehlende_pfade, soll) << "Protokoll:\n" << ist.protokoll();
}
void fordere_literal(const ParityErgebnis& ist, const std::string& literal) {
    EXPECT_THAT(ist.protokoll(), HasSubstr(literal));
}
void fordere_kein_literal(const ParityErgebnis& ist, const std::string& literal) {
    EXPECT_THAT(ist.protokoll(), testing::Not(HasSubstr(literal)));
}

GitlinkAntwort gitlink(const std::string& sha, const std::string& modus = "160000") {
    GitlinkAntwort antwort;
    antwort.werkzeug_ok = true;
    antwort.eintrag_vorhanden = true;
    antwort.modus = modus;
    antwort.objekt = sha;
    return antwort;
}

GitlinkAntwort ohne_eintrag() {
    GitlinkAntwort antwort;
    antwort.werkzeug_ok = true;  // git hat geantwortet: es gibt den Eintrag nicht
    return antwort;
}

void setze(FakeGitQuelle& git, GitlinkQuelle quelle, const std::string& pfad,
           const GitlinkAntwort& antwort) {
    if (quelle == GitlinkQuelle::Head) {
        git.gitlinks_head[pfad] = antwort;
    } else {
        git.gitlinks_index[pfad] = antwort;
    }
}

// =============================================================================
// DIE FALL-TABELLE, GEKREUZT MIT DER QUELLE-ACHSE.
// Beide Lesepfade werden IMMER gefahren -- head (ls-tree) und index (ls-files --stage)
// haben unterschiedliche Feldreihenfolgen, ein Fall auf nur einem Pfad deckt den
// anderen nicht.
// =============================================================================
enum class ParityBauart {
    BeideGleich,
    Divergent,
    LebenderFehlt,
    ToterFehlt,
    BeideFehlen,
    FalscherModus,
    ErwartetTrifft,
    ErwartetVerfehlt,
    GitKaputt,
};

struct ParityFall {
    const char* name;
    ParityBauart bauart;
    WacheStatus soll_status;
    std::optional<ParityRissArt> soll_riss;
    std::optional<ParityAbbruchGrund> soll_abbruch;
    std::vector<std::string> soll_literale;
    std::vector<std::string> verbotene_literale;
};

const std::vector<ParityFall>& parity_faelle() {
    static const std::vector<ParityFall> tabelle = {
        {"F01_beide_gleich_ist_gruen", ParityBauart::BeideGleich,
         WacheStatus::Gruen, std::nullopt, std::nullopt,
         {"Thesis-Gitlink-Paritaet OK", "NENNER: 2 Gitlink-Pfade geprueft"},
         {"FEHLER"}},

        {"F03_divergenz", ParityBauart::Divergent,
         WacheStatus::Riss, ParityRissArt::Divergenz, std::nullopt,
         {"die beiden Gitlinks DESSELBEN Repos divergieren",
          "beide Zeiger IMMER GEMEINSAM setzen"},
         {"Paritaet OK", "Gitlink FEHLT"}},

        // F04/F05 TOETEN DEN M1-MUTANTEN JETZT EBENFALLS -- in der Shell konnte das
        // nur F06, weil dort beide Zweige denselben rc trugen.
        {"F04_nur_der_lebende_fehlt", ParityBauart::LebenderFehlt,
         WacheStatus::Riss, ParityRissArt::GitlinkFehlt, std::nullopt,
         {"Gitlink FEHLT in Quelle", "fail-closed: ein fehlender Gitlink-Pfad ist ein FEHLER"},
         {"Paritaet OK", "divergieren"}},

        {"F05_nur_der_tote_fehlt", ParityBauart::ToterFehlt,
         WacheStatus::Riss, ParityRissArt::GitlinkFehlt, std::nullopt,
         {"Gitlink FEHLT in Quelle", "fail-closed"},
         {"Paritaet OK", "divergieren"}},

        {"F06_BEIDE_fehlen_der_schaerfste_fall", ParityBauart::BeideFehlen,
         WacheStatus::Riss, ParityRissArt::GitlinkFehlt, std::nullopt,
         {"Gitlink FEHLT in Quelle", "fail-closed"},
         {"Paritaet OK", "divergieren"}},

        {"F07_modus_100644_ist_kein_gitlink", ParityBauart::FalscherModus,
         WacheStatus::Riss, ParityRissArt::GitlinkFehlt, std::nullopt,
         {"Gitlink FEHLT in Quelle"},
         {"Paritaet OK"}},

        {"F08_erwartet_trifft", ParityBauart::ErwartetTrifft,
         WacheStatus::Gruen, std::nullopt, std::nullopt,
         {"Thesis-Gitlink-Paritaet OK"},
         {"erwartet war aber"}},

        {"F09_erwartet_verfehlt", ParityBauart::ErwartetVerfehlt,
         WacheStatus::Riss, ParityRissArt::ErwartetVerfehlt, std::nullopt,
         {"erwartet war aber"},
         {"Paritaet OK", "divergieren", "Gitlink FEHLT"}},

        {"F11_git_antwortet_nicht_ist_ABBRUCH", ParityBauart::GitKaputt,
         WacheStatus::Abbruch, std::nullopt, ParityAbbruchGrund::GitFehlgeschlagen,
         {"git hat die Gitlink-Abfrage nicht beantwortet"},
         {"Paritaet OK"}},
    };
    return tabelle;
}

class ParityFallTest : public testing::TestWithParam<std::tuple<ParityFall, GitlinkQuelle>> {};

TEST_P(ParityFallTest, Fall) {
    const ParityFall& fall = std::get<0>(GetParam());
    const GitlinkQuelle quelle = std::get<1>(GetParam());

    ASSERT_FALSE(fall.soll_literale.empty())
        << "Fall '" << fall.name << "' fordert kein Literal -- das genuegt nicht.";

    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string sha_a = wuerfel.sha40();
    const std::string sha_b = wuerfel.sha40();
    ASSERT_NE(sha_a, sha_b) << "Der Wuerfel hat zweimal denselben SHA geliefert.";

    FakeGitQuelle git;
    std::string erwartet;
    std::vector<std::string> soll_fehlende;

    switch (fall.bauart) {
        case ParityBauart::BeideGleich:
            setze(git, quelle, PFAD_LEBEND, gitlink(sha_a));
            setze(git, quelle, PFAD_TOT, gitlink(sha_a));
            break;
        case ParityBauart::Divergent:
            setze(git, quelle, PFAD_LEBEND, gitlink(sha_a));
            setze(git, quelle, PFAD_TOT, gitlink(sha_b));
            break;
        case ParityBauart::LebenderFehlt:
            setze(git, quelle, PFAD_LEBEND, ohne_eintrag());
            setze(git, quelle, PFAD_TOT, gitlink(sha_a));
            soll_fehlende = {PFAD_LEBEND};
            break;
        case ParityBauart::ToterFehlt:
            setze(git, quelle, PFAD_LEBEND, gitlink(sha_a));
            setze(git, quelle, PFAD_TOT, ohne_eintrag());
            soll_fehlende = {PFAD_TOT};
            break;
        case ParityBauart::BeideFehlen:
            setze(git, quelle, PFAD_LEBEND, ohne_eintrag());
            setze(git, quelle, PFAD_TOT, ohne_eintrag());
            soll_fehlende = {PFAD_LEBEND, PFAD_TOT};
            break;
        case ParityBauart::FalscherModus:
            setze(git, quelle, PFAD_LEBEND, gitlink(sha_a, "100644"));
            setze(git, quelle, PFAD_TOT, gitlink(sha_a));
            soll_fehlende = {PFAD_LEBEND};
            break;
        case ParityBauart::ErwartetTrifft:
            setze(git, quelle, PFAD_LEBEND, gitlink(sha_a));
            setze(git, quelle, PFAD_TOT, gitlink(sha_a));
            erwartet = sha_a;
            break;
        case ParityBauart::ErwartetVerfehlt:
            setze(git, quelle, PFAD_LEBEND, gitlink(sha_a));
            setze(git, quelle, PFAD_TOT, gitlink(sha_a));
            erwartet = sha_b;
            break;
        case ParityBauart::GitKaputt: {
            GitlinkAntwort kaputt;
            kaputt.werkzeug_ok = false;
            kaputt.diagnose = "git: ExecFehlgeschlagen bei Ausfuehrung (errno 2)";
            setze(git, quelle, PFAD_LEBEND, kaputt);
            setze(git, quelle, PFAD_TOT, kaputt);
            break;
        }
    }

    const ParityErgebnis ergebnis = pruefe_gitlink_paritaet(git, quelle, erwartet);

    fordere_status(ergebnis, fall.soll_status);
    if (fall.soll_abbruch.has_value()) {
        fordere_abbruch(ergebnis, *fall.soll_abbruch);
    } else if (fall.soll_riss.has_value()) {
        fordere_riss(ergebnis, *fall.soll_riss);
        fordere_nenner(ergebnis, 2);
        fordere_fehlende(ergebnis, soll_fehlende);
    } else {
        fordere_kein_riss(ergebnis);
        fordere_nenner(ergebnis, 2);
    }

    for (const std::string& literal : fall.soll_literale) fordere_literal(ergebnis, literal);
    for (const std::string& literal : fall.verbotene_literale) fordere_kein_literal(ergebnis, literal);

    // DER GEWUERFELTE SHA MUSS WOERTLICH ZURUECKKOMMEN (K13) -- und zwar der RICHTIGE:
    // eine Wache, die die zwei Zeiger vertauscht, faellt hier.
    if (fall.bauart == ParityBauart::Divergent) {
        fordere_literal(ergebnis, std::string(PFAD_LEBEND) + " = " + sha_a);
        fordere_literal(ergebnis, std::string(PFAD_TOT) + " = " + sha_b);
    }
    if (fall.bauart == ParityBauart::ErwartetVerfehlt) {
        fordere_literal(ergebnis, "stehen auf " + sha_a);
        fordere_literal(ergebnis, "erwartet war aber " + sha_b);
    }
    if (fall.soll_status == WacheStatus::Gruen) {
        fordere_literal(ergebnis, "beide Zeiger auf " + sha_a);
        // Der Mutant, der mit LEEREM SHA "OK" meldet, faellt hier ebenfalls.
        fordere_kein_literal(ergebnis, "beide Zeiger auf \n");
    }
    // DIE QUELLE STEHT IMMER IM PROTOKOLL -- eine Aussage ohne Lesepfad ist keine, denn
    // head und index koennen verschieden urteilen (das ist der Grund fuer zwei
    // Aufrufstellen). Ausdruecklich als "Quelle '<x>'" gefordert, nicht als blosses
    // Teilwort: "index" kaeme sonst zufaellig in einem Pfad durch und die Zusicherung
    // waere fuer eine der beiden Achsen geschenkt.
    fordere_literal(ergebnis, "Quelle '" + comdare::ci_wachen::quelle_text(quelle) + "'");
}

INSTANTIATE_TEST_SUITE_P(
    ParityWache, ParityFallTest,
    testing::Combine(testing::ValuesIn(parity_faelle()),
                     testing::ValuesIn(comdare::ci_wachen::alle_gitlink_quellen)),
    [](const testing::TestParamInfo<std::tuple<ParityFall, GitlinkQuelle>>& info) {
        return std::string(std::get<0>(info.param).name) + "_quelle_" +
               comdare::ci_wachen::quelle_text(std::get<1>(info.param));
    });

TEST(ParityWache, F11_KeinRepoIstAbbruchNiemalsGruen) {
    FakeGitQuelle git;
    git.arbeitsbaum = false;
    const ParityErgebnis ergebnis = pruefe_gitlink_paritaet(git, GitlinkQuelle::Head, "");
    fordere_status(ergebnis, WacheStatus::Abbruch);
    fordere_abbruch(ergebnis, ParityAbbruchGrund::KeinRepo);
    fordere_literal(ergebnis, "kein git-Repository");
    fordere_kein_literal(ergebnis, "Paritaet OK");
}

// =============================================================================
// DIE FELDREIHENFOLGE-FALLE -- reine Funktionen, ohne git, mit Eingaben, die es an
// echtem git gar nicht gibt.
//   ls-tree:          <mode> SP <type> SP <object> TAB <path>   Objekt = FELD 3
//   ls-files --stage: <mode> SP <object> SP <stage> TAB <path>  Objekt = FELD 2
// Wer sie verwechselt, liest bei --quelle index die Stage-Nummer als SHA und
// vergleicht zwei Nullen -- eine Wache, die immer gruen ist.
// =============================================================================
TEST(GitFeldParser, LsTreeLiestDasDritteFeldAlsObjekt) {
    const GitlinkAntwort a = parse_ls_tree_zeile("160000 commit deadbeefcafe\tthesis/diplomarbeit");
    EXPECT_TRUE(a.werkzeug_ok);
    EXPECT_TRUE(a.eintrag_vorhanden);
    EXPECT_EQ(a.modus, "160000");
    EXPECT_EQ(a.objekt, "deadbeefcafe");
    EXPECT_TRUE(a.ist_gitlink());
}

TEST(GitFeldParser, LsFilesStageLiestDasZWEITEFeldAlsObjekt) {
    const GitlinkAntwort a = parse_ls_files_stage_zeile("160000 deadbeefcafe 0\tthesis/diplomarbeit");
    EXPECT_EQ(a.objekt, "deadbeefcafe") << "Wird hier '0' gelesen, ist die Feldlage verwechselt.";
    EXPECT_NE(a.objekt, "0");
    EXPECT_TRUE(a.ist_gitlink());
}

TEST(GitFeldParser, GewoehnlicheDateiIstKeinGitlink) {
    const GitlinkAntwort a = parse_ls_files_stage_zeile("100644 abc123 0\tCode/datei.txt");
    EXPECT_TRUE(a.eintrag_vorhanden);
    EXPECT_EQ(a.modus, "100644");
    EXPECT_FALSE(a.ist_gitlink()) << "Modus 100644 ist kein Gitlink -- fail-closed.";
}

TEST(GitFeldParser, PfadMitLeerzeichenVerschiebtDieFeldlageNICHT) {
    // Der Pfad steht hinter einem TAB und wird deshalb nie als Feld gezaehlt.
    const GitlinkAntwort a = parse_ls_tree_zeile("160000 commit abcdef\tein pfad mit leerzeichen");
    EXPECT_EQ(a.objekt, "abcdef");
    EXPECT_TRUE(a.ist_gitlink());
}

TEST(GitFeldParser, MissgestalteteZeilenLiefernKeinenEintragStattEinesRatens) {
    for (const char* zeile : {"", "160000", "160000 commit", "\tnur ein pfad", "   "}) {
        const GitlinkAntwort a = parse_ls_tree_zeile(zeile);
        EXPECT_FALSE(a.eintrag_vorhanden) << "Zeile >>" << zeile << "<< wurde als Eintrag gedeutet.";
        EXPECT_FALSE(a.ist_gitlink());
    }
}

TEST(GitFeldParser, ModusGitlinkAberTypKeinCommitWirdNichtGeglaubt) {
    // Eine Zeile, die es an echtem git nicht gibt -- genau deshalb wird sie geprueft.
    const GitlinkAntwort a = parse_ls_tree_zeile("160000 blob abcdef\tthesis/diplomarbeit");
    EXPECT_FALSE(a.ist_gitlink());
}

TEST(GitNulTrenner, DateinameMitZeilenendeBleibtEINEintrag) {
    // Der Positiv-Fall, der den toten Nenner-Mismatch-Zweig der Shell-Wache ersetzt.
    const std::string roh = std::string("a\nb.xml\0c.xml\0", 14);
    const std::vector<std::string> teile = comdare::ci_wachen::trenne_nul(roh);
    ASSERT_EQ(teile.size(), 2u);
    EXPECT_EQ(teile[0], "a\nb.xml");
    EXPECT_EQ(teile[1], "c.xml");
}

// =============================================================================
// DER argv-PARSER -- in der Shell nur ueber einen Kindprozess und rc=2 beobachtbar.
// =============================================================================
TEST(ParityArgv, VorgabeIstHeadOhneErwartung) {
    const ParityArgumente a = parse_parity_argumente({});
    EXPECT_TRUE(a.ok);
    EXPECT_FALSE(a.hilfe_gewuenscht);
    EXPECT_EQ(a.quelle, GitlinkQuelle::Head);
    EXPECT_TRUE(a.erwartet.empty());
}

TEST(ParityArgv, BeideAufrufstellenFormenWerdenVerstanden) {
    const ParityArgumente head = parse_parity_argumente({"--quelle", "head"});
    ASSERT_TRUE(head.ok) << head.fehler;
    EXPECT_EQ(head.quelle, GitlinkQuelle::Head);

    const ParityArgumente index = parse_parity_argumente({"--quelle", "index", "--erwartet", "abc123"});
    ASSERT_TRUE(index.ok) << index.fehler;
    EXPECT_EQ(index.quelle, GitlinkQuelle::Index);
    EXPECT_EQ(index.erwartet, "abc123");
}

TEST(ParityArgv, F10_QuelleUnsinnIstBedienfehlerMitLiteral) {
    const ParityArgumente a = parse_parity_argumente({"--quelle", "kopf"});
    EXPECT_FALSE(a.ok);
    EXPECT_THAT(a.fehler, HasSubstr("--quelle muss 'head' oder 'index' sein, war 'kopf'"));
}

TEST(ParityArgv, F12_BedienfehlerVierEingaenge) {
    EXPECT_FALSE(parse_parity_argumente({"--quelle"}).ok);
    EXPECT_THAT(parse_parity_argumente({"--quelle"}).fehler, HasSubstr("--quelle ohne Wert"));
    EXPECT_FALSE(parse_parity_argumente({"--erwartet"}).ok);
    EXPECT_THAT(parse_parity_argumente({"--erwartet"}).fehler, HasSubstr("--erwartet ohne Wert"));
    EXPECT_FALSE(parse_parity_argumente({"--unbekannt"}).ok);
    EXPECT_THAT(parse_parity_argumente({"--unbekannt"}).fehler, HasSubstr("unbekannte Option"));
    EXPECT_FALSE(parse_parity_argumente({"stray"}).ok);
}

TEST(ParityArgv, HilfeIstKeinFehler) {
    for (const char* flagge : {"-h", "--hilfe", "--help"}) {
        const ParityArgumente a = parse_parity_argumente({flagge});
        EXPECT_TRUE(a.ok) << flagge;
        EXPECT_TRUE(a.hilfe_gewuenscht) << flagge;
    }
    EXPECT_THAT(comdare::ci_wachen::hilfe_text(), HasSubstr("--quelle head|index"));
}

// =============================================================================
// STUFE 1: VOLLSTAENDIGKEIT.
// =============================================================================
TEST(ParityVollstaendigkeit, JedeRissArtKommtAlsSollVor) {
    std::set<ParityRissArt> gefordert;
    for (const ParityFall& fall : parity_faelle()) {
        if (fall.soll_riss.has_value()) gefordert.insert(*fall.soll_riss);
    }
    for (const ParityRissArt art : comdare::ci_wachen::alle_parity_riss_arten) {
        EXPECT_TRUE(gefordert.count(art) == 1)
            << "Kein Fall fordert die Riss-Art '" << art << "' -- dieser Zweig ist ungedeckt.";
    }
}

TEST(ParityVollstaendigkeit, JederAbbruchGrundKommtAlsSollVor) {
    std::set<ParityAbbruchGrund> gefordert;
    for (const ParityFall& fall : parity_faelle()) {
        if (fall.soll_abbruch.has_value()) gefordert.insert(*fall.soll_abbruch);
    }
    gefordert.insert(ParityAbbruchGrund::KeinRepo);      // ParityWache.F11_KeinRepo...
    gefordert.insert(ParityAbbruchGrund::Bedienfehler);  // ParityArgv.F10_/F12_ + E2E
    for (const ParityAbbruchGrund grund : comdare::ci_wachen::alle_parity_abbruch_gruende) {
        EXPECT_TRUE(gefordert.count(grund) == 1)
            << "Kein Fall fordert den Abbruch-Grund '" << grund << "' -- dieser Zweig ist ungedeckt.";
    }
}

TEST(ParityVollstaendigkeit, BeideLesepfadeWerdenGefahren) {
    // Ohne diese Zusicherung koennte jemand die Quelle-Achse aus dem INSTANTIATE
    // entfernen und die halbe Deckung verlieren, ohne dass etwas rot wird.
    EXPECT_EQ(std::size(comdare::ci_wachen::alle_gitlink_quellen), 2u);
}

// =============================================================================
// STUFE 2: DER SELBSTBISS.
// =============================================================================
ParityErgebnis faelschung_m1_fehlt_zweig_entfernt() {
    // M1: der fail-closed-Zweig faellt heraus. IN DER SHELL war das nur sichtbar, wenn
    // BEIDE Gitlinks fehlten (dann waren die leeren Zeiger gleich und der Mutant lief
    // bis zum Schluss-echo durch). Hier reicht EIN fehlender Pfad.
    ParityErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 2;
    return ist;
}

ParityErgebnis faelschung_m1b_faellt_erst_im_divergenz_zweig() {
    // DIE KOLLISION, ausdruecklich als Faelschung nachgebaut: der Mutant meldet einen
    // Riss -- aber den FALSCHEN. In der rc-Domaene war er von M1 nicht zu trennen.
    ParityErgebnis ist;
    ist.status = WacheStatus::Riss;
    ist.riss = ParityRissArt::Divergenz;
    ist.nenner = 2;
    ist.sha_lebend = "aaaa";
    return ist;
}

ParityErgebnis faelschung_m2_divergenz_zweig_entfernt() {
    ParityErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 2;
    ist.sha_lebend = "aaaa";
    ist.sha_tot = "bbbb";
    return ist;
}

ParityErgebnis faelschung_m3_erwartet_zweig_entfernt() {
    ParityErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 2;
    ist.sha_lebend = "aaaa";
    ist.sha_tot = "aaaa";
    ist.erwartet = "bbbb";
    return ist;
}

ParityErgebnis faelschung_m5_kein_repo_zweig_entfernt() {
    ParityErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 2;
    return ist;
}

ParityErgebnis faelschung_leerer_sha_meldet_ok() {
    // Der Mutant, der in der Shell "Paritaet OK ... beide Zeiger auf " mit LEEREM SHA
    // meldete und mit rc=0 endete. Der gewuerfelte SHA fehlt -- das Literal faellt.
    ParityErgebnis ist;
    ist.status = WacheStatus::Gruen;
    ist.nenner = 2;
    return ist;
}

TEST(ParitySelbstbiss, M1_StatusForderungFaelltAmFehltZweigMutanten) {
    EXPECT_NONFATAL_FAILURE(fordere_status(faelschung_m1_fehlt_zweig_entfernt(), WacheStatus::Riss),
                            "RISS");
}

TEST(ParitySelbstbiss, M1_LiteralFailClosedFehltAmMutanten) {
    EXPECT_NONFATAL_FAILURE(fordere_literal(faelschung_m1_fehlt_zweig_entfernt(), "Gitlink FEHLT"),
                            "Gitlink FEHLT");
}

TEST(ParitySelbstbiss, M1b_DIE_KOLLISION_WIRD_JETZT_GETOETET) {
    // DER ZENTRALE BEWEIS DIESES UMBAUS. Der Mutant meldet Riss -- in der rc-Domaene
    // also rc=1 wie das Original, ununterscheidbar. Erst weil die Riss-ART ein Wert
    // ist, faellt er. GENAU DAS kostete die abgeloeste Probe 28 Zeilen Messprotokoll
    // und liess ihr nur EINEN toetenden Eingang.
    EXPECT_NONFATAL_FAILURE(
        fordere_riss(faelschung_m1b_faellt_erst_im_divergenz_zweig(), ParityRissArt::GitlinkFehlt),
        "GitlinkFehlt");
}

TEST(ParitySelbstbiss, M2_DivergenzZweigMutantWirdGetoetet) {
    EXPECT_NONFATAL_FAILURE(fordere_riss(faelschung_m2_divergenz_zweig_entfernt(), ParityRissArt::Divergenz),
                            "Divergenz");
}

TEST(ParitySelbstbiss, M2_LiteralGemeinsamSetzenFehltAmMutanten) {
    EXPECT_NONFATAL_FAILURE(
        fordere_literal(faelschung_m2_divergenz_zweig_entfernt(), "beide Zeiger IMMER GEMEINSAM setzen"),
        "GEMEINSAM");
}

TEST(ParitySelbstbiss, M3_ErwartetZweigMutantWirdGetoetet) {
    EXPECT_NONFATAL_FAILURE(
        fordere_riss(faelschung_m3_erwartet_zweig_entfernt(), ParityRissArt::ErwartetVerfehlt),
        "ErwartetVerfehlt");
}

TEST(ParitySelbstbiss, M5_KeinRepoZweigMutantWirdGetoetet) {
    EXPECT_NONFATAL_FAILURE(
        fordere_abbruch(faelschung_m5_kein_repo_zweig_entfernt(), ParityAbbruchGrund::KeinRepo),
        "KeinRepo");
}

TEST(ParitySelbstbiss, LeererShaMeldetKeinOK) {
    EXPECT_NONFATAL_FAILURE(
        fordere_literal(faelschung_leerer_sha_meldet_ok(), "beide Zeiger auf 0123456789abcdef"),
        "0123456789abcdef");
}

TEST(ParitySelbstbiss, GegenprobeDieHelferSchweigenAmGesundenErgebnis) {
    ParityErgebnis gesund;
    gesund.status = WacheStatus::Riss;
    gesund.riss = ParityRissArt::GitlinkFehlt;
    gesund.nenner = 2;
    gesund.fehlende_pfade = {PFAD_LEBEND};

    fordere_status(gesund, WacheStatus::Riss);
    fordere_riss(gesund, ParityRissArt::GitlinkFehlt);
    fordere_nenner(gesund, 2);
    fordere_fehlende(gesund, {PFAD_LEBEND});
    fordere_literal(gesund, "Gitlink FEHLT");
    fordere_kein_literal(gesund, "Paritaet OK");
}

// =============================================================================
// GEGEN DAS ECHTE git: beide Lesepfade an einem Wegwerf-Repo.
// Gitlinks werden ohne Submodule gesetzt (Index-Eintrag mit Modus 160000) -- kein Netz,
// kein Klon, keine Submodul-Initialisierung.
// =============================================================================
class ParityEchtesGit : public testing::TestWithParam<GitlinkQuelle> {};

TEST_P(ParityEchtesGit, GleicheZeigerSindGruen) {
    const GitlinkQuelle quelle = GetParam();
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string sha = wuerfel.sha40();

    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_LEBEND, "160000", sha));
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_TOT, "160000", sha));
    // GEGENPROBE am Objekt: der Modus steht wirklich auf 160000.
    ASSERT_EQ(repo.index_modus(PFAD_LEBEND), "160000");
    if (quelle == GitlinkQuelle::Head) {
        ASSERT_TRUE(repo.committe("gitlinks"));
    }

    const EchteGitQuelle git{repo.pfad()};
    ASSERT_TRUE(git.ist_arbeitsbaum());
    const ParityErgebnis ergebnis = pruefe_gitlink_paritaet(git, quelle, "");

    fordere_status(ergebnis, WacheStatus::Gruen);
    fordere_literal(ergebnis, "beide Zeiger auf " + sha);  // der GEWUERFELTE SHA, woertlich
}

TEST_P(ParityEchtesGit, DivergenteZeigerReissenMitBEIDENShas) {
    const GitlinkQuelle quelle = GetParam();
    Wuerfel wuerfel;
    RecordProperty("wuerfel_seed", std::to_string(wuerfel.seed()));
    const std::string sha_a = wuerfel.sha40();
    const std::string sha_b = wuerfel.sha40();
    ASSERT_NE(sha_a, sha_b);

    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_LEBEND, "160000", sha_a));
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_TOT, "160000", sha_b));
    if (quelle == GitlinkQuelle::Head) {
        ASSERT_TRUE(repo.committe("gitlinks"));
    }

    const EchteGitQuelle git{repo.pfad()};
    const ParityErgebnis ergebnis = pruefe_gitlink_paritaet(git, quelle, "");

    fordere_status(ergebnis, WacheStatus::Riss);
    fordere_riss(ergebnis, ParityRissArt::Divergenz);
    // Die Zuordnung Pfad -> SHA wird woertlich gefordert: eine Wache, die die zwei
    // Zeiger vertauscht, faellt hier und nur hier.
    fordere_literal(ergebnis, std::string(PFAD_LEBEND) + " = " + sha_a);
    fordere_literal(ergebnis, std::string(PFAD_TOT) + " = " + sha_b);
}

INSTANTIATE_TEST_SUITE_P(BeideLesepfade, ParityEchtesGit,
                         testing::ValuesIn(comdare::ci_wachen::alle_gitlink_quellen),
                         [](const testing::TestParamInfo<GitlinkQuelle>& info) {
                             return comdare::ci_wachen::quelle_text(info.param);
                         });

// =============================================================================
// E2E: DER CLI-VERTRAG DER ZWEI AUFRUFSTELLEN.
// =============================================================================
#ifdef COMDARE_CI_WACHE_PARITY_BINARY
ProzessAusgang rufe_wache(const std::filesystem::path& wo, const std::vector<std::string>& argumente) {
    ProzessAuftrag auftrag;
    auftrag.argv = {COMDARE_CI_WACHE_PARITY_BINARY};
    for (const std::string& a : argumente) auftrag.argv.push_back(a);
    auftrag.arbeitsverzeichnis = wo;
    return comdare::ci_wachen::fuehre_aus(auftrag);
}

TEST(ParityE2E, GruenLiefertExit0) {
    Wuerfel wuerfel;
    const std::string sha = wuerfel.sha40();
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_LEBEND, "160000", sha));
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_TOT, "160000", sha));

    const ProzessAusgang ausgang = rufe_wache(repo.pfad(), {"--quelle", "index", "--erwartet", sha});
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{0}) << ausgang.fehler;
    EXPECT_THAT(ausgang.ausgabe, HasSubstr("beide Zeiger auf " + sha));
}

TEST(ParityE2E, RissLiefertExit1) {
    Wuerfel wuerfel;
    const std::string sha_a = wuerfel.sha40();
    const std::string sha_b = wuerfel.sha40();
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_LEBEND, "160000", sha_a));
    ASSERT_TRUE(repo.setze_index_eintrag(PFAD_TOT, "160000", sha_b));

    const ProzessAusgang ausgang = rufe_wache(repo.pfad(), {"--quelle", "index"});
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{1});
    EXPECT_THAT(ausgang.fehler, HasSubstr("divergieren"));
}

TEST(ParityE2E, BedienfehlerLiefertExit2) {
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    const ProzessAusgang ausgang = rufe_wache(repo.pfad(), {"--quelle", "kopf"});
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{2});
    EXPECT_THAT(ausgang.fehler, HasSubstr("--quelle muss 'head' oder 'index' sein"));
}

TEST(ParityE2E, HilfeLiefertExit0) {
    FixtureRepo repo;
    ASSERT_TRUE(repo.init());
    const ProzessAusgang ausgang = rufe_wache(repo.pfad(), {"--hilfe"});
    ASSERT_EQ(ausgang.art, ProzessArt::Exit) << ausgang.beschreibung();
    EXPECT_EQ(exit_code(ausgang), std::optional<int>{0});
    EXPECT_THAT(ausgang.ausgabe, HasSubstr("--quelle head|index"));
}
#endif  // COMDARE_CI_WACHE_PARITY_BINARY

}  // namespace
