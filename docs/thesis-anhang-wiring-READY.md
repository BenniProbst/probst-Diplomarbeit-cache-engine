# READY-TO-APPLY — Thesis-Anhang-Verdrahtung der 4 neuen Darstellungen (#24 Abschluss)

> **Status:** fertig vorbereitet, NICHT ins Thesis-Submodul committet. Das Submodul `thesis/diplomarbeit`
> ist die **Overleaf-gekoppelte** `20260931-overleaf-diplomarbeit` (Branch `main`) — ein Commit dorthin erscheint
> im Live-Overleaf-Dokument (outward-facing). Der ÄNDERUNGS-INHALT ist autorisiert (`A_measurements.tex` ist
> explizit AUTO-BEFUELLT + dokumentiert „hier \input-Zeilen hinzufuegen"); nur der COMMIT ins Live-Dokument
> braucht das User-GO. Anwenden = die Blöcke unten in `anhang/{de,en}/A_measurements.tex` einfügen, Submodul
> committen + Gitlink bumpen. `\InputIfFileExists` = kompiliert sauber auch VOR dem ersten Messlauf (honest-empty),
> füllt sich, sobald `appendix_generator` die Dateien aus den #9916-Messdaten erzeugt.

Der Generator (`08_appendix_generator`) erzeugt bereits `seg_attribution.tex`, `latency_range.tex`,
`latency_ecdf.tex`, `exchange_forest.tex` je Sprache (Inc-2a, verifiziert). Diese 4 sind noch nirgends `\input`et.

## Einfügen in `anhang/de/A_measurements.tex` (nach der bestehenden Surface-Sektion)

```latex
\section{Per-Achsen-Latenz-Attribution}\label{sec:measurements:seg-attribution}

Abbildung~\ref{fig:seg-attribution} zerlegt die Segment-Laufzeit je Suchverfahren in die Beitr\"age der
einzelnen Organ-Achsen (gestapelte Balken). Das 100\,\%-Ganze je Balken ist die Wall-Clock des separaten
19-Segment-Laufs (\texttt{seg\_run\_total\_ns}), \emph{nicht} die Real-Workload-Latenz (\texttt{total\_ns});
die 20 Segmente (19 Organ-Achsen + Framework-Rest) summieren sich exakt zu dieser Basis (Coverage $\approx 1{,}0$).

\InputIfFileExists{anhang/de/tabellen/seg_attribution.tex}{}{%
  \emph{(Diese Darstellung erscheint nach dem n\"achsten Messlauf mit \texttt{seg\_*\_ns}-Spalten.)}}

\section{Latenz-Verteilung}\label{sec:measurements:latency-distribution}

Die Range-Balken (Abbildung~\ref{fig:latency-range}) zeigen je Suchverfahren und Operation die
p50--p99-Spanne (Punkt bei p50, Whisker zu p99); da nur diese beiden Perzentile gemessen werden, wird
bewusst \emph{kein} Box-Plot mit interpolierten Quartilen gezeichnet. Die ECDF (Abbildung~\ref{fig:latency-ecdf})
stellt die Verteilung der Gesamt-Latenz \emph{\"uber die Konfigurationen} dar (Anteil der Permutationen mit
\texttt{ns\_per\_op} $\le x$) --- keine Per-Operation-CDF, da die Rohsamples je Operation nicht vorliegen.

\InputIfFileExists{anhang/de/tabellen/latency_range.tex}{}{%
  \emph{(p50--p99-Range erscheint nach dem n\"achsten Messlauf.)}}
\InputIfFileExists{anhang/de/tabellen/latency_ecdf.tex}{}{%
  \emph{(Config-ECDF erscheint nach dem n\"achsten Messlauf.)}}
```

## Ans Ende der bestehenden `\section{Achsen-Austauschbarkeit}` (nach den ld\_exchange-Longtables) anf\"ugen

```latex
Abbildung~\ref{fig:ld:exchange:forest} fasst die Austauschbarkeit der \texttt{ns\_per\_op}-Kennzahl als
Forest-Plot zusammen (Punkt = Median rel.\ $\Delta$, Whisker = IQR, 0-Referenzlinie; kleine-$n$-Zeilen
ausgegraut). Der Whisker ist um den Median symmetrisch (\"uber die IQR-Breite), da das Aggregat nur die
IQR-Breite, nicht die Quartilsgrenzen tr\"agt.

\InputIfFileExists{anhang/de/tabellen/exchange_forest.tex}{}{%
  \emph{(Forest-Plot erscheint nach dem n\"achsten Messlauf.)}}
```

## `anhang/en/A_measurements.tex` — spiegelbildlich (EN-Captions)

Analog mit englischen \"Uberschriften/Prosa: „Per-axis latency attribution", „Latency distribution",
und der Forest-Plot-Absatz unter „Axis exchangeability". `\InputIfFileExists{anhang/en/tabellen/<name>.tex}`.

## Direktiven-Konformit\"at
- **Sequenzielles Referenzieren:** alle `\ref` verweisen auf Floats DERSELBEN oder EINER FR\"UHEREN Stelle
  (die 4 neuen Sektionen kommen NACH den bestehenden; ihre eigenen `\label` werden lokal referenziert).
- **Tabellen-Legende als Notiz unter dem Float:** die Generator-`.tex` tragen ihre Caption bereits selbst
  (figure+caption vom Writer emittiert); die Prosa oben ist die Einf\"uhrung, keine doppelte Legende.
- **Nur autorisierte Inhalte:** `A_measurements.tex` ist AUTO-BEFUELLT (Datei-Kopf); \input-Erg\"anzung ist
  der dokumentierte Workflow, keine freie Prosa-\"Anderung.
