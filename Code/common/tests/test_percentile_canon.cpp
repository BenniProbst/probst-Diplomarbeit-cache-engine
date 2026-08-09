// T-5 -- Kreuz-Test des super-seitigen Perzentil-KANONs (Paket D5-2, 2026-08-09).
//
// WOGEGEN DIESER TEST GEBAUT IST
//   Die bestehende Suite beider Stufen ist an dieser Fehlerklasse VORBEIGELAUFEN: ihre
//   scharfen Perzentil-Literale liegen samtlich auf UNGERADER Stichprobenlaenge. Auf
//   ungerader Laenge liefern der Kanon (k = ceil(q*n)-1) und die verworfene Abschrift
//   (k = round(q*(n-1))) DENSELBEN Index -- ein Test dort beweist nichts. Die Formeln
//   divergieren auf GERADER Laenge, und nur dort.
//   Ein richtiges Messgeraet am falschen Gegenstand faellt nie auf; nichts klappert.
//
// WOHER DIE SOLLWERTE KOMMEN (T-5)
//   Von Hand aus k = ceil(q*n) - 1 gerechnet und hier als Literale eingefroren. NICHT aus
//   der geprueften Funktion abgelesen und NICHT aus dem Kritik-Material abgeschrieben.
//   Gegenprobe der Handrechnung: fuer 1..100 (n=100) ergibt der Kanon p50=50, die verworfene
//   Formel 51 -- dieselbe Divergenz, die latency_stats.hpp unabhaengig im Klartext nennt.
//
// DER GEGENEINGANG (T-4)
//   Zu der Zusicherung "der Index stammt aus ceil(q*n)-1" gehoert ein zweiter, unabhaengiger
//   Eingang: kleinster_wert_mit_deckung() setzt die DEFINIERENDE EIGENSCHAFT direkt um --
//   "P(q) ist der KLEINSTE Stichprobenwert v, fuer den mindestens q*n Werte <= v sind" --
//   durch Zaehlen, ohne jede Rang-Formel. Der Zufallslauf prueft Kanon gegen dieses Orakel.
//
// DER KOEDER (K13)
//   Die Koeder-Faelle unten sind so gewaehlt, dass die verworfene Formel an ihnen SCHEITERT.
//   Nachgewiesen vor dem Bau: 7 von 13 Kanon-Sollwerten verfehlt sie. Wuerde die alte Formel
//   je zurueckkehren, faellt dieser Test -- er ist keine blinde Wache.
//
// NENNER IN DIE AUSGABE
//   Der Test druckt, wie viele Faelle er geprueft hat, wie viele davon gerade Laenge haben
//   und an wie vielen die verworfene Formel abweicht. Eine Wache mit unvollstaendigem Nenner
//   meldet Vollstaendigkeit und deckt nichts.

#include "percentile_canon.hpp"

#include <gtest/gtest.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <random>
#include <string>
#include <vector>

namespace {

namespace stats = comdare::da::stats;

// ---------------------------------------------------------------------------------------------
// Die VERWORFENE Formel -- absichtlich hier nachgebaut, damit der Test zeigen kann, dass er
// zwischen beiden UNTERSCHEIDET. Sie ist Pruefgegenstand, nicht Sollwert-Quelle.
[[nodiscard]] double verworfene_formel(std::vector<double> v, double q) {
    if (v.empty()) return 0.0;
    std::sort(v.begin(), v.end());
    std::size_t rang = static_cast<std::size_t>(q * static_cast<double>(v.size() - 1) + 0.5);
    if (rang >= v.size()) rang = v.size() - 1;
    return v[rang];
}

// ---------------------------------------------------------------------------------------------
// GEGENEINGANG (T-4): die definierende Eigenschaft, direkt gezaehlt. Kein ceil, kein Rang.
// "P(q) = kleinster Stichprobenwert v, fuer den mindestens q*n Stichprobenwerte <= v sind."
// Die Toleranz faengt denselben Rundungsfall ab, den der Kanon mit rang_schutz behandelt:
// q*n liegt fuer binaer nicht exakt darstellbare q minimal ueber der gemeinten ganzen Zahl.
// 1e-9 ist um Groessenordnungen groesser als der Rundungsfehler und um Groessenordnungen
// kleiner als der kleinste gewollte Rang-Unterschied (der ist 1).
[[nodiscard]] double kleinster_wert_mit_deckung(std::vector<double> v, double q) {
    if (v.empty()) return 0.0;
    std::sort(v.begin(), v.end());
    double const noetig = q * static_cast<double>(v.size()) - 1e-9;
    for (double kandidat : v) {
        std::size_t deckung = 0;
        for (double x : v)
            if (x <= kandidat) ++deckung;
        if (static_cast<double>(deckung) >= noetig) return kandidat;
    }
    return v.back();
}

struct HandFall {
    char const*         name;
    std::vector<double> feld;
    double              q;
    double              soll; // VON HAND: k = ceil(q*n) - 1
};

[[nodiscard]] std::vector<double> eins_bis(int n) {
    std::vector<double> v;
    v.reserve(static_cast<std::size_t>(n));
    for (int i = 1; i <= n; ++i) v.push_back(static_cast<double>(i));
    return v;
}

// GERADE Laenge -- hier und nur hier trennen sich Kanon und verworfene Formel.
[[nodiscard]] std::vector<HandFall> gerade_faelle() {
    return {
        {"n=2 q=.50", {7, 9}, 0.50, 7},
        {"n=4 q=.25", {10, 20, 30, 40}, 0.25, 10},
        {"n=4 q=.50", {10, 20, 30, 40}, 0.50, 20},
        {"n=4 q=.75", {10, 20, 30, 40}, 0.75, 30},
        {"n=6 q=.50", {1, 2, 3, 4, 5, 6}, 0.50, 3},
        {"n=8 q=.25", {1, 2, 3, 4, 5, 6, 7, 8}, 0.25, 2},
        {"n=8 q=.50", {1, 2, 3, 4, 5, 6, 7, 8}, 0.50, 4},
        {"n=8 q=.75", {1, 2, 3, 4, 5, 6, 7, 8}, 0.75, 6},
        {"n=100 q=.50", eins_bis(100), 0.50, 50},
        {"n=100 q=.95", eins_bis(100), 0.95, 95},
        {"n=100 q=.99", eins_bis(100), 0.99, 99},
    };
}

// UNGERADE Laenge -- Kontrollgruppe. Sie belegt, WARUM die alte Suite blind war.
[[nodiscard]] std::vector<HandFall> ungerade_faelle() {
    return {
        {"n=1 q=.50", {42}, 0.50, 42},
        {"n=5 q=.50", {1, 2, 3, 4, 5}, 0.50, 3},
        {"n=7 q=.50", {1, 2, 3, 4, 5, 6, 7}, 0.50, 4},
        {"n=9 q=.25", {1, 2, 3, 4, 5, 6, 7, 8, 9}, 0.25, 3},
        {"n=99 q=.50", eins_bis(99), 0.50, 50},
    };
}

[[nodiscard]] std::uint64_t seed_bestimmen() {
    if (char const* s = std::getenv("COMDARE_D52_SEED"); s != nullptr && *s != '\0')
        return std::strtoull(s, nullptr, 10);
    return std::random_device{}();
}

} // namespace

// =============================================================================================
// 1) GERADE LAENGE -- der eigentliche Kreuz-Test.
TEST(PercentileCanonD52, GeradeLaengeTrifftHandwerte) {
    auto const faelle    = gerade_faelle();
    int        divergent = 0;
    for (auto const& f : faelle) {
        SCOPED_TRACE(f.name);
        EXPECT_DOUBLE_EQ(stats::nearest_rank_quantile(f.feld, f.q), f.soll)
            << "Kanon verfehlt den Handwert bei " << f.name;
        if (verworfene_formel(f.feld, f.q) != f.soll) ++divergent;
    }
    std::printf("[D5-2] gerade Laenge: %zu Faelle geprueft, an %d davon weicht die VERWORFENE "
                "Formel vom Handwert ab\n",
                faelle.size(), divergent);
    // K13: der Koeder muss beissen. Waere die alte Formel noch aktiv, traefe sie diese
    // Handwerte nicht -- ein Kreuz-Test, an dem beide Formeln bestehen, waere blind.
    EXPECT_GT(divergent, 0) << "Kreuz-Test ist blind: die verworfene Formel bestuende ihn auch";
}

// 2) Der Median ist der Sonderfall q=0.5 -- UNTERE Mitte bei geradem n.
TEST(PercentileCanonD52, MedianIstUntereMitteBeiGeradem_n) {
    EXPECT_DOUBLE_EQ(stats::nearest_rank_median({10, 20, 30, 40}), 20.0);
    EXPECT_DOUBLE_EQ(stats::nearest_rank_median({7, 9}), 7.0);
    EXPECT_DOUBLE_EQ(stats::nearest_rank_median({1, 2, 3, 4, 5, 6}), 3.0);
    // Ausdruecklich NICHT: das Mittel der beiden mittleren Werte (waere 25 / 8 / 3.5),
    // und ausdruecklich NICHT die OBERE Mitte (waere 30 / 9 / 4) -- dort landete die
    // Abschrift, die super bis heute trug.
    EXPECT_NE(stats::nearest_rank_median({10, 20, 30, 40}), 25.0);
    EXPECT_NE(stats::nearest_rank_median({10, 20, 30, 40}), 30.0);
}

// 3) Quartile -- eine Sortierung, drei Kanon-Indizes, alle von Hand.
TEST(PercentileCanonD52, QuartileAufGeraderLaenge) {
    auto const q4 = stats::nearest_rank_quartiles({10, 20, 30, 40});
    EXPECT_DOUBLE_EQ(q4.p25, 10.0);
    EXPECT_DOUBLE_EQ(q4.p50, 20.0);
    EXPECT_DOUBLE_EQ(q4.p75, 30.0);
    auto const q8 = stats::nearest_rank_quartiles({1, 2, 3, 4, 5, 6, 7, 8});
    EXPECT_DOUBLE_EQ(q8.p25, 2.0);
    EXPECT_DOUBLE_EQ(q8.p50, 4.0);
    EXPECT_DOUBLE_EQ(q8.p75, 6.0);
}

// 4) KONTROLLGRUPPE: auf ungerader Laenge stimmen beide Formeln ueberein.
//    Dieser Test schlaegt NICHT fehl -- er dokumentiert die Blindstelle der Alt-Suite.
TEST(PercentileCanonD52, UngeradeLaengeIstBlindstelle) {
    auto const faelle = ungerade_faelle();
    int        gleich = 0;
    for (auto const& f : faelle) {
        SCOPED_TRACE(f.name);
        EXPECT_DOUBLE_EQ(stats::nearest_rank_quantile(f.feld, f.q), f.soll);
        if (verworfene_formel(f.feld, f.q) == f.soll) ++gleich;
    }
    std::printf("[D5-2] ungerade Laenge: %zu von %zu Faellen wuerde auch die VERWORFENE Formel "
                "bestehen -- darum beweist ein Test dort nichts\n",
                static_cast<std::size_t>(gleich), faelle.size());
    EXPECT_EQ(static_cast<std::size_t>(gleich), faelle.size());
}

// 5) ZUFALLSLAUF gegen den Gegeneingang (T-4), ausschliesslich auf GERADER Laenge.
//    Der Seed wird gedruckt; COMDARE_D52_SEED=<zahl> spielt einen Lauf exakt nach.
TEST(PercentileCanonD52, ZufallGegenBruteForceOrakelGeradeLaenge) {
    std::uint64_t const seed = seed_bestimmen();
    std::printf("[D5-2] SEED=%llu  (Nachspielen: COMDARE_D52_SEED=%llu ctest -R "
                "PercentileCanonD52)\n",
                static_cast<unsigned long long>(seed), static_cast<unsigned long long>(seed));
    std::fflush(stdout);

    std::mt19937_64                        rng(seed);
    std::uniform_int_distribution<int>     laenge_halb(1, 60); // n = 2*halb -> immer GERADE
    std::uniform_real_distribution<double> wert(-1000.0, 1000.0);
    double const                           quantile[] = {0.05, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99};

    int laeufe = 0, divergent_zur_alten = 0;
    for (int iter = 0; iter < 400; ++iter) {
        std::size_t const   n = static_cast<std::size_t>(2 * laenge_halb(rng));
        std::vector<double> v;
        v.reserve(n);
        for (std::size_t i = 0; i < n; ++i) v.push_back(wert(rng));
        ASSERT_EQ(n % 2u, 0u) << "Zufallslauf muss auf GERADER Laenge laufen";

        for (double q : quantile) {
            double const kanon  = stats::nearest_rank_quantile(v, q);
            double const orakel = kleinster_wert_mit_deckung(v, q);
            ASSERT_DOUBLE_EQ(kanon, orakel)
                << "Kanon weicht vom Gegeneingang ab: SEED=" << seed << " n=" << n << " q=" << q;
            ++laeufe;
            if (verworfene_formel(v, q) != kanon) ++divergent_zur_alten;
        }
    }
    std::printf("[D5-2] Zufallslauf: %d Vergleiche gegen den Gegeneingang, alle gleich; an %d "
                "davon haette die VERWORFENE Formel abgewichen\n",
                laeufe, divergent_zur_alten);
    EXPECT_GT(divergent_zur_alten, 0) << "Zufallslauf ist blind: die verworfene Formel haette ihn auch bestanden";
}

// 6) Randfaelle: leere Stichprobe und Klemmung.
TEST(PercentileCanonD52, RandfaelleLeerUndKlemmung) {
    EXPECT_DOUBLE_EQ(stats::nearest_rank_median({}), 0.0);
    EXPECT_DOUBLE_EQ(stats::nearest_rank_quantile({}, 0.99), 0.0);
    auto const leer = stats::nearest_rank_quartiles({});
    EXPECT_DOUBLE_EQ(leer.p25, 0.0);
    EXPECT_DOUBLE_EQ(leer.p50, 0.0);
    EXPECT_DOUBLE_EQ(leer.p75, 0.0);
    // q ausserhalb [0,1] wird im Kanon geklemmt: q<=0 -> kleinster, q>=1 -> groesster Wert.
    EXPECT_DOUBLE_EQ(stats::nearest_rank_quantile({10, 20, 30, 40}, 0.0), 10.0);
    EXPECT_DOUBLE_EQ(stats::nearest_rank_quantile({10, 20, 30, 40}, 1.0), 40.0);
}
