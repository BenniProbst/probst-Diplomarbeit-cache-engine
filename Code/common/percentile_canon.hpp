#pragma once
// D5-2 (2026-08-09) -- super-seitiger Zugang zum PERZENTIL-KANON der cache-engine.
//
// @subsystem super/Code (geteilt von 04_csv_to_latex und 05_diagram_generator)
//
// WARUM DIESE DATEI EXISTIERT
//   Bis heute trugen 04_csv_to_latex und 05_diagram_generator die Perzentil-Formel als
//   ABSCHRIFT: drei eigene Rumpfe mit rank = (size_t)(q*(n-1)+0.5), also round(q*(n-1)).
//   Diese Formel ist in der ce am 2026-08-09 (D5-1, Commit c98b4b95) ausdruecklich VERWORFEN
//   und dort ersatzlos geloescht worden. Die Loeschung blieb hier folgenlos, weil super die
//   Formel abgeschrieben statt gerufen hat: eine Loeschung ist eine Wache gegen AUFRUFER,
//   nicht gegen KOPIEN. Es gab null Aufrufer und darum kein Klappern.
//
// DIE ANTWORT DARAUF IST AUFRUF, NICHT BESSERE ABSCHRIFT
//   Diese Datei enthaelt KEINE Rang-Formel. Der einzige Umrechner Quantil -> Feld-Index ist
//   cache_engine::builder::commands::stats::nearest_rank_index aus
//   libs/cache_engine/builder/commands/latency_stats.hpp. Wird der ce-Kanon geaendert oder
//   geloescht, bricht super ab sofort beim UEBERSETZEN -- das ist die Wache, die vorher fehlte.
//
//   Der Weg ist der im Haus bereits eingefuehrte: 02_messung_driver bindet mit
//   <cache_engine/builder/commands/welch_t_test.hpp> das SCHWESTER-Header derselben
//   ce-Verzeichnisses ein (Include-Wurzel ${COMDARE_CACHE_ENGINE_DIR}/libs, reiner
//   Lese-Zugriff, KEIN Link gegen ce-Code). latency_stats.hpp ist header-only und zieht nur
//   Standard-Header nach -- es entsteht keine neue Bau-Abhaengigkeit.
//
// DER KANON (Wortlaut siehe latency_stats.hpp)
//   Nearest Rank, Hyndman/Fan 1996 Typ 1:
//     ordinaler Rang R(q,n) = ceil(q*n)   1-basiert
//     Feld-Index     k(q,n) = R(q,n) - 1  0-basiert, in das AUFSTEIGEND sortierte Feld
//   Der MEDIAN ist der Fall q=0.5 und KEINE eigene Bauart. Bei GERADEM n liefert er die
//   UNTERE Mitte (n=4 -> Index 1), NICHT das Mittel der beiden mittleren Werte.
//
// GELTUNGSBEREICH -- bewusst entschieden, nicht stillschweigend mitgezogen
//   Die super-Aufrufer mitteln zwei verschiedene Grundgesamtheiten:
//     (a) ueber MESSPROBEN        (04:216/411/513/1245/1367/1414, 05:735/1548)
//     (b) ueber KONFIGURATIONEN   (05:1205/1783/1784 -- Mediane ueber bereits aggregierte
//         p50/p99 je Algorithmus x Op-Art, also Mediane ueber Mediane)
//   Der Kanon gilt fuer BEIDE, und das ist eine Entscheidung mit Begruendung:
//     1. Der Kanon definiert den OPERATOR Median, nicht die Grundgesamtheit. latency_stats.hpp
//        sagt woertlich, der Median sei "der Fall q=0.5 und KEINE eigene Bauart".
//     2. Die definierende Eigenschaft -- das Ergebnis ist IMMER ein real vorliegender Wert und
//        nie ein erfundener -- ist bei (b) eher noch wichtiger als bei (a): das Mittel zweier
//        Algorithmen ist eine Zahl, die KEIN Algorithmus erreicht hat.
//     3. Sonst druckt die Arbeit zwei verschieden gerechnete Groessen unter EINEM Namen
//        "Median" -- genau die Fehlerklasse, gegen die D5 gebaut ist.
//   Wer das je zurueckdrehen will, aendert diesen Block und die Aufrufer bewusst -- nicht
//   versehentlich durch eine neue Abschrift.
//
// FOLGE (Owner-KERN "Invalidieren ist das Ziel"): alle vor dem 2026-08-09 aus 04/05 erzeugten
// Median-/Quartil-Zahlen sind nach einer ANDEREN Definition gerechnet. Die Messdaten selbst
// werden NICHT geloescht.
//
// SELBSTCHECK
//   ZUSICHERT: In 04_csv_to_latex und 05_diagram_generator gibt es keine zweite Rang-Formel
//              mehr; jede Median-/Quartil-Zahl beider Stufen laeuft ueber nearest_rank_index.
//   ZUSICHERT NICHT: nichts ueber ce-interne Aufrufer (die deckt D5-1 ab), nichts ueber
//              eta_kalibrierung::median_t_s (ce-seitig, mittelt bei geradem n) und nichts
//              ueber das HDR-Histogramm (eigenes Verfahren, D5-5).

#include <cache_engine/builder/commands/latency_stats.hpp>

#include <algorithm>
#include <cstddef>
#include <utility>
#include <vector>

namespace comdare::da::stats {

namespace ce_canon = ::comdare::cache_engine::builder::commands::stats;

/// Quantil einer double-Stichprobe nach dem KANON. Leere Stichprobe -> 0.0.
/// Der Index kommt AUSSCHLIESSLICH aus ce_canon::nearest_rank_index -- hier steht keine
/// zweite Formel. Non-mutierend nach aussen (die Kopie kommt per Wert herein).
[[nodiscard]] inline double nearest_rank_quantile(std::vector<double> v, double q) {
    if (v.empty()) return 0.0;
    std::sort(v.begin(), v.end());
    return v[ce_canon::nearest_rank_index(v.size(), q)];
}

/// Median = der Fall q=0.5 desselben Verfahrens. Bei geradem n die UNTERE Mitte.
[[nodiscard]] inline double nearest_rank_median(std::vector<double> v) {
    return nearest_rank_quantile(std::move(v), 0.5);
}

struct Quartiles {
    double p25 = 0.0, p50 = 0.0, p75 = 0.0;
};

/// p25/p50/p75 aus EINER Sortierung, alle drei ueber denselben Kanon-Index.
[[nodiscard]] inline Quartiles nearest_rank_quartiles(std::vector<double> v) {
    Quartiles q;
    if (v.empty()) return q;
    std::sort(v.begin(), v.end());
    q.p25 = v[ce_canon::nearest_rank_index(v.size(), 0.25)];
    q.p50 = v[ce_canon::nearest_rank_index(v.size(), 0.50)];
    q.p75 = v[ce_canon::nearest_rank_index(v.size(), 0.75)];
    return q;
}

} // namespace comdare::da::stats
