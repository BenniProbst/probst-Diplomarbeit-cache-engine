// -----------------------------------------------------------------------------------------------
// test_mess_bestand_belegung.cpp -- Unit-Gate der HOST-BELEGUNG des Messwert-Genus (LAG-P2-Rest).
//
// WAS ER ZUSICHERT (T-2: Wert/Klasse, NICHT Anwesenheit):
//   * die Entscheidung liefert fuer eine gegebene Eingabe GENAU EINE benannte Klasse und, wenn
//     aktiv, EXAKT den Doc-Key und EXAKT die Maschine, die hineingingen;
//   * der gebundene Schluessel traegt fuer DIESE Maschine DIESEN 128-hex-Wert -- verglichen gegen
//     ein UNABHAENGIG gerechnetes Orakel (s.u.), nicht gegen sich selbst;
//   * jede Zusicherung hat einen GEGENEINGANG, bei dem sie NICHT gilt.
//
// DAS ORAKEL IST UNABHAENGIG (T-5). Die beiden Sollwerte unten wurden NICHT vom Prueflingscode
// erzeugt, sondern extern mit coreutils gerechnet -- einer anderen SHA-512-Implementierung:
//     FP=b41bf465...66ac7d                     (frisch gewuerfelt aus /dev/urandom, K13)
//     printf '%s\n%s' "$FP" "prod1" | sha512sum
//     printf '%s\n%s' "$FP" "prod2" | sha512sum
// Die Preimage-Regel dafuer steht in ce und ist dort compile-hart gewacht: die Komponenten werden
// mit GENAU EINEM '\n' dazwischen verkettet (kein fuehrender, kein abschliessender Separator) --
// anatomy_fingerprint.hpp:82 (kAnatomyFingerprintSeparator) + :707-710 (die EINE Preimage-
// Konstruktion), gehasht in bestandslog_index.hpp:61-68 (derive_key_from_lines), Komponenten-
// Reihenfolge [Fingerprint, Hardware] aus messwert_key_source.hpp:93-96.
// Waere eine dieser vier Stellen anders, als dieser Test annimmt, MUESSTE er scheitern -- genau
// das ist der Zweck: er prueft die Kette, nicht meine Lesart von ihr.
//
// GEGENSTAND (Prueffrage 2): geprueft wird die BELEGUNG DES HOSTS, nicht die ce-Ableitung. Dass
// sha512 richtig rechnet, ist ce-seitig in tests/unit/test_lagp2_messwert_genus.cpp abgenommen.
// Hier gilt die Frage: kommt die Maschinen-Identitaet, die der Treiber entschieden hat, WIRKLICH
// im Schluessel an -- und wird eine widerspruechliche Belegung abgelehnt statt gebunden.
//
// Gate-frei: reine Host-Logik plus zwei Dateien im temporaeren Verzeichnis. Kein Treiber-Lauf,
// keine Messdaten, kein Netz, kein Objekt-Store.
// ASCII-only.
// -----------------------------------------------------------------------------------------------

#include "mess_bestand_belegung.hpp"

#include <chrono>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <string>
#include <string_view>

namespace md = comdare::diplomarbeit::messung_driver;
namespace fs = std::filesystem;

static int g_fail   = 0;
static int g_checks = 0;

static void check(bool ok, char const* msg) {
    ++g_checks;
    std::printf("  [%s] %s\n", ok ? "OK" : "FAIL", msg);
    if (!ok) ++g_fail;
}

static void check_eq(std::string_view ist, std::string_view soll, char const* msg) {
    ++g_checks;
    bool const ok = (ist == soll);
    std::printf("  [%s] %s\n", ok ? "OK" : "FAIL", msg);
    if (!ok) {
        std::printf("         soll = '%.*s'\n", static_cast<int>(soll.size()), soll.data());
        std::printf("         ist  = '%.*s'\n", static_cast<int>(ist.size()), ist.data());
        ++g_fail;
    }
}

// -- Die frisch gewuerfelte Testbinary-Identitaet und die extern gerechneten Sollwerte -----------
static constexpr char const* kFingerprint =
    "b41bf4653e59791b0661eac9f871a19b192d4213bd0e036997a3eaa1044e7f02"
    "d9c62f8621ecc394077d7276ca1b77c872aeb49faeec5605b89d39207966ac7d";
static constexpr char const* kSollProd1 =
    "9e3fea4dd36c05d3646f1e68205336d6353c19312beeb0c13797accf79f277ae"
    "25b2a7ba75ccc566f7d30eb0d9295b95e163eac5e461c99e21c6d98ad8ae71f3";
static constexpr char const* kSollProd2 =
    "30b64719cdda16e2e6c10baf69d256be13954130cea619681f20aab5bc83f102"
    "d613ac4eb1a4617f67da5677d37f7f4205722ea1fe2888e533407fea1df04f7d";

// Der Doc-Key der BINARY-Seite, wie ci/comdare_bestandslog_activation.sh:128 ihn setzt.
static constexpr char const* kBinaryDocKey = "bestandslog/binary_bestand.xml";
// Der Doc-Key der MESS-Seite, wie dieselbe Datei ihn ab dieser Scheibe setzt.
static constexpr char const* kMessDocKey = "bestandslog/mess_bestand.xml";

// Eindeutiges Testverzeichnis JE LAUF. Ein festes Tempdir plus remove_all ist die Falle, an der
// sich parallele Instanzen gegenseitig zerstoeren (Aufraeum-Kandidat (30) im Ledger) -- deshalb
// eine Lauf-Kennung im Namen. std::chrono statt getpid, damit die Datei ohne <unistd.h> auskommt
// (main.cpp dieses Targets baut ausdruecklich auch gegen Win32).
static std::string lauf_kennung() {
    static std::string const k =
        std::to_string(static_cast<unsigned long long>(std::chrono::steady_clock::now().time_since_epoch().count()));
    return k;
}

static fs::path mach_zell_verzeichnis(char const* stem, std::string_view sidecar_inhalt, bool mit_sidecar) {
    fs::path const d = fs::temp_directory_path() / ("comdare_mbb_" + lauf_kennung() + "_" + stem);
    fs::create_directories(d);
    { std::ofstream{d / "perm.dll", std::ios::binary} << "nicht-die-echte-binary"; }
    if (mit_sidecar) {
        std::ofstream f{d / "perm.dll.fingerprint", std::ios::binary};
        f << sidecar_inhalt;
    }
    return d;
}

int main() {
    using K = md::MessBelegungKlasse;

    std::printf("== TEIL 1: die reine Entscheidung (belege_mess_bestand) ==\n");

    // (1) Der Normalfall -- und zwar auf WERT geprueft, nicht auf "hat was gesetzt".
    {
        auto const b = md::belege_mess_bestand("prod1", kBinaryDocKey, kMessDocKey);
        check(b.klasse == K::aktiv, "prod1 + eigener Mess-Doc-Key -> aktiv");
        check(b.aktiv(), "aktiv() sagt true");
        check(!b.abgelehnt(), "abgelehnt() sagt false");
        check_eq(b.doc_key, kMessDocKey, "doc_key traegt EXAKT den Mess-Doc-Key");
        check_eq(b.maschine, "prod1", "maschine traegt EXAKT 'prod1'");
    }

    // (1b) DIESELBE Zusicherung fuer eine ANDERE Maschine -- damit 'prod1' nicht bloss ein
    //      zufaellig passender fester Wert im Pruefling ist.
    {
        auto const b = md::belege_mess_bestand("prod2", kBinaryDocKey, kMessDocKey);
        check(b.klasse == K::aktiv, "prod2 + eigener Mess-Doc-Key -> aktiv");
        check_eq(b.maschine, "prod2", "maschine traegt EXAKT 'prod2' (nicht prod1)");
    }

    // (2) GEGENEINGANG zu (1): die Realm-Kollision. Zwei Anspruchsteller auf EIN Dokument.
    {
        auto const b = md::belege_mess_bestand("prod1", kBinaryDocKey, kBinaryDocKey);
        check(b.klasse == K::realm_kollision, "Mess-Doc-Key == Binary-Doc-Key -> realm_kollision");
        check(!b.aktiv(), "Realm-Kollision ist NICHT aktiv");
        check(b.abgelehnt(), "Realm-Kollision ist eine ABLEHNUNG (Aufrufer muss abbrechen)");
        check(b.doc_key.empty() && b.maschine.empty(), "abgelehnte Belegung gibt KEINE Werte heraus");
    }

    // (2b) Die Kollision muss NACH dem Trimmen erkannt werden -- sonst schluepft sie durch, sobald
    //      eine CI-Variable ein Leerzeichen mitbringt. Das ist der eigentliche Fehlerfall.
    {
        auto const b = md::belege_mess_bestand("prod1", kBinaryDocKey, "  bestandslog/binary_bestand.xml  ");
        check(b.klasse == K::realm_kollision, "Kollision wird auch mit Randweiss erkannt (Trim VOR Vergleich)");
    }

    // (3) GEGENEINGANG zu (1): leere Maschinen-Identitaet.
    {
        auto const b = md::belege_mess_bestand("", kBinaryDocKey, kMessDocKey);
        check(b.klasse == K::maschine_leer, "leere Maschine -> maschine_leer");
        check(b.abgelehnt(), "leere Maschine ist eine ABLEHNUNG");
    }
    {
        auto const b = md::belege_mess_bestand("   ", kBinaryDocKey, kMessDocKey);
        check(b.klasse == K::maschine_leer, "nur Randweiss als Maschine -> maschine_leer");
    }

    // (4) inert-by-default: kein Mess-Doc-Key -> AUS, und das ist ausdruecklich KEIN Fehler.
    {
        auto const b = md::belege_mess_bestand("prod1", kBinaryDocKey, "");
        check(b.klasse == K::aus, "kein Mess-Doc-Key -> aus");
        check(!b.aktiv() && !b.abgelehnt(), "aus ist weder aktiv noch abgelehnt");
    }
    {
        auto const b = md::belege_mess_bestand("prod1", kBinaryDocKey, "   ");
        check(b.klasse == K::aus, "nur Randweiss als Mess-Doc-Key -> aus");
    }
    // (4b) 'aus' schlaegt 'maschine_leer': wer nichts verlangt, dem ist nichts abzulehnen.
    {
        auto const b = md::belege_mess_bestand("", kBinaryDocKey, "");
        check(b.klasse == K::aus, "nichts verlangt + keine Maschine -> aus (keine Ablehnung)");
    }

    // (5) Randweiss am Doc-Key wird abgeschnitten -- der gebundene Wert ist der getrimmte.
    {
        auto const b = md::belege_mess_bestand("  prod1 ", kBinaryDocKey, "  bestandslog/mess_bestand.xml ");
        check(b.klasse == K::aktiv, "Randweiss ringsum -> immer noch aktiv");
        check_eq(b.doc_key, kMessDocKey, "doc_key ist getrimmt gebunden");
        check_eq(b.maschine, "prod1", "maschine ist getrimmt gebunden");
    }

    // (6) to_string: jede Klasse hat ihr eigenes Etikett. Ein Etikett, das zwei Klassen teilen,
    //     macht den Log-Kanal blind -- dieselbe Klasse Fehler wie ein verdeckter exit-Zweig.
    {
        check_eq(md::to_string(K::aktiv), "aktiv", "Etikett aktiv");
        check_eq(md::to_string(K::aus), "aus", "Etikett aus");
        check_eq(md::to_string(K::maschine_leer), "maschine_leer", "Etikett maschine_leer");
        check_eq(md::to_string(K::realm_kollision), "realm_kollision", "Etikett realm_kollision");
    }

    std::printf("\n== TEIL 2: der gebundene Schluessel (make_mess_bestand_key_fn) ==\n");

    fs::path const zelle = mach_zell_verzeichnis("gut", kFingerprint, true);

    // (7) T-2 IM KERN: DIESER Wert fuer DIESE Maschine -- gegen das extern gerechnete Orakel.
    {
        auto const  fn = md::make_mess_bestand_key_fn("prod1");
        auto const  k  = fn(zelle);
        check(k.has_value(), "prod1: Schluessel wird geliefert");
        if (k) check_eq(*k, kSollProd1, "prod1: Schluessel == extern gerechnetes Orakel (sha512sum)");
    }
    {
        auto const  fn = md::make_mess_bestand_key_fn("prod2");
        auto const  k  = fn(zelle);
        check(k.has_value(), "prod2: Schluessel wird geliefert");
        if (k) check_eq(*k, kSollProd2, "prod2: Schluessel == extern gerechnetes Orakel (sha512sum)");
    }

    // (8) Die Maschine MUSS den Schluessel bewegen. Waere sie unterwegs verloren gegangen, waeren
    //     beide Schluessel gleich -- und prod2 wuerde Messungen von prod1 als eigene ueberspringen.
    {
        auto const k1 = md::make_mess_bestand_key_fn("prod1")(zelle);
        auto const k2 = md::make_mess_bestand_key_fn("prod2")(zelle);
        check(k1 && k2 && *k1 != *k2, "zwei Maschinen, dieselbe Zelle -> VERSCHIEDENE Schluessel");
    }

    // (9) Stabilitaet: derselbe Eingang zweimal -> derselbe Schluessel. Streute er, gaebe es nie
    //     einen lager_hit und damit nie den vom Owner geforderten SKIP.
    {
        auto const fn = md::make_mess_bestand_key_fn("prod1");
        check(fn(zelle) == fn(zelle), "derselbe Eingang zweimal -> derselbe Schluessel");
    }

    // (10) GEGENEINGANG: leere Hardware-Identitaet -> KEIN Schluessel. Das ist die Belegung, in
    //      der zwei Maschinen fuer dieselbe Zelle ununterscheidbar waeren.
    {
        auto const k = md::make_mess_bestand_key_fn("")(zelle);
        check(!k.has_value(), "leere Maschine -> KEIN Schluessel (fehlerklasse=hardware_leer)");
    }

    // (11) GEGENEINGAENGE der geerbten Sidecar-Fehlerklassen: ohne Sidecar, leer, zu kurz,
    //      Nicht-Hex. Alle vier muessen fail-closed sein -- ein Eintrag ohne Anker ist schlimmer
    //      als kein Eintrag.
    {
        auto const ohne = mach_zell_verzeichnis("ohne", "", false);
        check(!md::make_mess_bestand_key_fn("prod1")(ohne).has_value(), "kein Sidecar -> kein Schluessel");

        auto const leer = mach_zell_verzeichnis("leer", "", true);
        check(!md::make_mess_bestand_key_fn("prod1")(leer).has_value(), "leeres Sidecar -> kein Schluessel");

        auto const kurz = mach_zell_verzeichnis("kurz", "abc123", true);
        check(!md::make_mess_bestand_key_fn("prod1")(kurz).has_value(), "zu kurzes Sidecar -> kein Schluessel");

        std::string nichthex(128, 'z');
        auto const  nhex = mach_zell_verzeichnis("nhex", nichthex, true);
        check(!md::make_mess_bestand_key_fn("prod1")(nhex).has_value(), "Nicht-Hex-Sidecar -> kein Schluessel");

        fs::remove_all(ohne);
        fs::remove_all(leer);
        fs::remove_all(kurz);
        fs::remove_all(nhex);
    }

    fs::remove_all(zelle);

    // -- NENNER: nie eine nackte Zahl, und die Grundgesamtheit kommt von AUSSEN (T-3) -----------
    std::printf("\n-----------------------------------------------------------------------------\n");
    std::printf("NENNER:\n");
    std::printf("  %d Zusicherungen gefahren, %d gerissen.\n", g_checks, g_fail);
    std::printf("  Grundgesamtheit A -- Belegungs-Klassen: 4 von 4 abgedeckt\n");
    std::printf("    (aktiv, aus, maschine_leer, realm_kollision; jede mit eigenem Gegeneingang).\n");
    std::printf("  Grundgesamtheit B -- ce-Fehlerklassen des Schluessel-Providers: 5 von 5 belegt\n");
    std::printf("    (sidecar_fehlt, sidecar_leer, laenge_verstoss, zeichen_verstoss, hardware_leer;\n");
    std::printf("     Quelle: ce messwert_key_source.hpp Kopf, NICHT dieser Pruefling).\n");
    std::printf("  Grundgesamtheit C -- mess_bestand_*-Felder in ce LazyRunConfig: 3 deklariert\n");
    std::printf("    (iterator :318 doc_key, :319 key_of, :322 versions).\n");
    std::printf("    2 davon belegt der Host ab dieser Scheibe; versions bleibt BEWUSST unbelegt\n");
    std::printf("    (keine Quelle im Host -- Begruendung im Kopf von mess_bestand_belegung.hpp).\n");
    std::printf("  Orakel: extern mit coreutils sha512sum gerechnet, nicht vom Pruefling.\n");
    std::printf("-----------------------------------------------------------------------------\n");
    std::printf("%s: %d Fehler\n", g_fail == 0 ? "PASS" : "FAIL", g_fail);
    return g_fail == 0 ? 0 : 1;
}
