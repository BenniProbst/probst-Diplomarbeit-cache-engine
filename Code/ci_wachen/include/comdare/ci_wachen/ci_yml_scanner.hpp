// ci_yml_scanner.hpp -- der Job-Block-Scanner fuer .gitlab-ci.yml.        (2026-08-09)
//
// ER ERSETZT ZWEI KONSTRUKTE DER ABGELOESTEN PROBEN, DIE BEIDE MESSBAR ZU WENIG SAHEN:
//
//  (1) DIE REGISTRIERUNGS-PRUEFUNG MASS TEXT STATT AUSFUEHRUNG.
//      `grep -cF -- 'sh scripts/ci_xml_wellformed_guard.sh' .gitlab-ci.yml` zaehlt
//      JEDES Vorkommen der Zeichenfolge -- auch in einem KOMMENTAR. Ein auskommentierter
//      Aufruf haette die Zusage "die Wache laeuft in mindestens einem Job" erfuellt,
//      obwohl sie in keinem Job mehr laeuft. Hier zaehlt nur, was in einem Job-Block
//      steht und keine Kommentarzeile ist.
//
//  (2) DIE allow_failure-WACHE SAH NUR DIE PROBEN-JOBS, NICHT DIE WACHEN-JOBS.
//      Am Objekt gegengeprueft (09.08., beide Probendateien): der awk-Blockscanner lief
//      ausschliesslich ueber
//          JOB='test:xml-wellformed-probe:'      (xml_wellformed_probe.sh:570)
//          JOB='test:thesis-gitlink-probe:'      (thesis_gitlink_parity_probe.sh:534)
//      Die Job-Bloecke, in denen die WACHEN wirklich gerufen werden --
//      lint:xml-wellformed, verify:submodules, anhang:forward -- wurden NIE auf
//      allow_failure geprueft. Ein `allow_failure: true` an einem von ihnen haette die
//      scharfe Wache advisory gemacht, ohne dass irgendetwas rot geworden waere.
//      Genau diese drei Bloecke stehen jetzt mit in der Forderung.
//      (allow_failure ist seit dem 06.07. verboten: ZELLE = Warnung, JOB = hart rot.)
//
// DAS BLOCKENDE BLEIBT, WIE ES WAR -- und das ist Absicht, kein Uebersehen: eine Zeile
// in SPALTE 0 beendet den Block, KOMMENTARZEILEN AUSDRUECKLICH EINGESCHLOSSEN. Nimmt
// man '#' vom Blockende aus, laeuft der Block in den Kommentarkopf des NAECHSTEN Jobs
// und meldet dort ein allow_failure, das es im Job nie gab. In dieser Datei stehen
// job-interne Kommentare stets eingerueckt; Spalte 0 trennt die Jobs. Ein eigener
// Testfall friert das ein.
//
// TESTKRITIK (T-9): das ist ein strenger ZEILEN-Scanner, kein YAML-Parser. YAML-Anker,
// `extends` auf ein verstecktes Template und `include`-Dateien sieht er nicht. Die
// abgeloesten awk-Bloecke sahen sie ebenfalls nicht -- kein Rueckschritt, aber benannt.
//
// ASCII-only, Zeilen <= 120 Byte.

#ifndef COMDARE_CI_WACHEN_CI_YML_SCANNER_HPP
#define COMDARE_CI_WACHEN_CI_YML_SCANNER_HPP

#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::ci_wachen {

struct JobBlock {
    std::string              name;
    std::size_t              erste_zeile = 0; // 1-basiert, wie ein Editor zaehlt
    std::vector<std::string> zeilen;          // einschliesslich der Job-Kopfzeile
};

// Lesen ist fail-closed: eine fehlende oder unlesbare Datei liefert nullopt, nie eine
// leere Liste. "Datei weg" und "Datei leer" duerfen nicht denselben Wert haben.
std::optional<std::vector<std::string>> lies_zeilen(const std::filesystem::path& datei);

// Der Block eines Jobs. nullopt = der Job existiert nicht (nicht: er ist leer).
std::optional<JobBlock> finde_job_block(const std::vector<std::string>& zeilen, const std::string& jobname);

// Zaehlt Vorkommen eines Literals in NICHT-Kommentarzeilen. Fuehrende Leerzeichen
// zaehlen nicht als Inhalt; entscheidend ist das erste Nicht-Leerzeichen.
std::size_t zaehle_wirksam(const std::vector<std::string>& zeilen, std::string_view literal);

// Zaehlt Vorkommen einschliesslich Kommentarzeilen -- ausschliesslich als GEGENPROBE
// benutzt, damit "0 wirksam" von "0 ueberhaupt" unterscheidbar bleibt.
std::size_t zaehle_roh(const std::vector<std::string>& zeilen, std::string_view literal);

bool ist_kommentarzeile(std::string_view zeile);

} // namespace comdare::ci_wachen

#endif // COMDARE_CI_WACHEN_CI_YML_SCANNER_HPP
