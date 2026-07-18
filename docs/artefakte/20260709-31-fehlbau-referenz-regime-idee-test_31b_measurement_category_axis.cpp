// #31-Schritt-2/A2 (F7 Kategorie-Achse M): Trait-Test der additiven compile-time-Kategorie-Achse M über den
// bestehenden enum MeasurementCategory. Beweist: die 16 Kategorien sind compile-time-iterierbar (Achse M) UND
// der constexpr-Regime-Klassifikator (Observer/Counter/Derived) + das PMC-Privilegien-Gate sind konsistent
// (Doc 15 §2/§4). golden/ABI-neutral (Enum unverändert, kein POD-Touch, reiner static_assert/Trait-Test).

#include <cache_engine/measurement/measurement_category_axis.hpp>

#include <boost/mp11.hpp>

#include <gtest/gtest.h>

#include <cstddef>

namespace ms = ::comdare::cache_engine::measurement;
namespace mp = ::boost::mp11;

static_assert(ms::measurement_category_count == 16, "Achse M = 16 MeasurementCategory compile-time.");

TEST(MeasurementCategoryAxis, SixteenCategoriesCompileTimeIterable) {
    // Die Achse M iteriert generisch über genau die 16 MeasurementCategory-Werte.
    std::size_t n = 0;
    mp::mp_for_each<ms::measurement_category_list>([&](auto tag) {
        ++n;
        (void)tag;
    });
    EXPECT_EQ(n, 16u);
}

TEST(MeasurementCategoryAxis, RegimePartitionsAllSixteen) {
    // Jede der 16 Kategorien fällt in genau ein Regime; die Zählung ergibt die erwartete 7/7/2-Aufteilung
    // (Counter: 6 HW-Counter + Fill-Buffer; Derived: CLU + IPC/CPI; Observer: Latenz×5 + Durchsatz + Footprint).
    std::size_t observer = 0, counter = 0, derived = 0;
    mp::mp_for_each<ms::measurement_category_list>([&]<class Tag>(Tag) {
        constexpr ms::MeasurementCategory C = Tag::value;
        switch (ms::category_regime(C)) {
            case ms::MeasurementRegime::Observer: ++observer; break;
            case ms::MeasurementRegime::Counter: ++counter; break;
            case ms::MeasurementRegime::Derived: ++derived; break;
        }
    });
    EXPECT_EQ(observer, 7u);
    EXPECT_EQ(counter, 7u);
    EXPECT_EQ(derived, 2u);
    EXPECT_EQ(observer + counter + derived, 16u);
}

TEST(MeasurementCategoryAxis, RegimeTableIsExact) {
    // Punktuelle Regime-Belege (Doc 15 §2): Cache/dTLB/Branch/Energie/Fill-Buffer = Counter,
    // CLU/IPC-CPI = Derived, Latenz/Durchsatz/Footprint = Observer.
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::CACHE_MISS_L1), ms::MeasurementRegime::Counter);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::CACHE_MISS_L3), ms::MeasurementRegime::Counter);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::DTLB_MISS), ms::MeasurementRegime::Counter);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::BRANCH_MISS), ms::MeasurementRegime::Counter);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::ENERGY_J), ms::MeasurementRegime::Counter);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::FILL_BUFFER_OCCUPANCY), ms::MeasurementRegime::Counter);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::CLU), ms::MeasurementRegime::Derived);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::IPC_CPI), ms::MeasurementRegime::Derived);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::MEMORY_FOOTPRINT), ms::MeasurementRegime::Observer);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::LATENCY_MEAN), ms::MeasurementRegime::Observer);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::LATENCY_P999), ms::MeasurementRegime::Observer);
    EXPECT_EQ(ms::category_regime(ms::MeasurementCategory::THROUGHPUT), ms::MeasurementRegime::Observer);
}

TEST(MeasurementCategoryAxis, NeedsPmcMatchesNonObserverRegime) {
    // Das PMC-Privilegien-Gate (Doc 15 §4) ist genau die Nicht-Observer-Menge: Counter + Derived brauchen
    // privilegierte PMC-Rohdaten, Observer nicht.
    mp::mp_for_each<ms::measurement_category_list>([&]<class Tag>(Tag) {
        constexpr ms::MeasurementCategory C     = Tag::value;
        const bool                        needs = ms::category_needs_pmc(C);
        const bool is_observer                  = (ms::category_regime(C) == ms::MeasurementRegime::Observer);
        EXPECT_EQ(needs, !is_observer);
    });
}
