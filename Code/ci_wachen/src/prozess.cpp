// prozess.cpp -- Umsetzung der Prozess-Naht (Begruendung im Kopf von prozess.hpp).
// ASCII-only, Zeilen <= 120 Byte.

#include "comdare/ci_wachen/prozess.hpp"

#include <cerrno>
#include <cstdlib>
#include <cstring>

#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

namespace comdare::ci_wachen {
namespace {

// Nutzlast der Selbst-Pipe. Gelingt exec, wird sie nie geschrieben (FD_CLOEXEC).
struct ExecMeldung {
    int stufe  = 0; // 1 = chdir, 2 = execvp
    int fehler = 0; // errno
};

// Ein Rohr, das der Vater bis EOF leert.
struct Leser {
    int          fd    = -1;
    std::string* senke = nullptr;
    bool         offen = false;
};

void schliesse(int& fd) {
    if (fd >= 0) {
        ::close(fd);
        fd = -1;
    }
}

} // namespace

std::string ProzessAusgang::beschreibung() const {
    std::string text = werkzeug.empty() ? std::string("<ohne Werkzeug>") : werkzeug;
    switch (art) {
        case ProzessArt::Exit: return text + ": Exit(" + std::to_string(code) + ")";
        case ProzessArt::Signal:
            return text + ": Signal(" + std::to_string(code) + ") -- der Prozess starb, er endete nicht";
        case ProzessArt::ExecFehlgeschlagen: {
            const char* wo = (stufe == ExecStufe::Arbeitsverzeichnis) ? "Arbeitsverzeichnis"
                             : (stufe == ExecStufe::Ausfuehrung)      ? "Ausfuehrung"
                                                                      : "unbekannt";
            return text + ": ExecFehlgeschlagen bei " + wo + " (errno " + std::to_string(code) + ": " +
                   std::strerror(code) + ") -- der Prozess LIEF NIE, es gibt keinen Exit-Code";
        }
    }
    return text + ": <unbekannte ProzessArt>";
}

std::optional<int> exit_code(const ProzessAusgang& ausgang) {
    if (ausgang.art != ProzessArt::Exit) {
        return std::nullopt; // DER RIEGEL: kein Exit -> kein Code, nie ein Zahlenvergleich
    }
    return ausgang.code;
}

ProzessAusgang fuehre_aus(const ProzessAuftrag& auftrag) {
    ProzessAusgang aus;
    aus.werkzeug = auftrag.argv.empty() ? std::string() : auftrag.argv.front();

    if (auftrag.argv.empty()) {
        aus.art   = ProzessArt::ExecFehlgeschlagen;
        aus.stufe = ExecStufe::Ausfuehrung;
        aus.code  = EINVAL;
        return aus;
    }

    int rohr_out[2]  = {-1, -1};
    int rohr_err[2]  = {-1, -1};
    int rohr_exec[2] = {-1, -1};

    auto abbruch_mit = [&](int fehlernummer, ExecStufe stufe) {
        schliesse(rohr_out[0]);
        schliesse(rohr_out[1]);
        schliesse(rohr_err[0]);
        schliesse(rohr_err[1]);
        schliesse(rohr_exec[0]);
        schliesse(rohr_exec[1]);
        aus.art   = ProzessArt::ExecFehlgeschlagen;
        aus.stufe = stufe;
        aus.code  = fehlernummer;
        return aus;
    };

    if (::pipe(rohr_out) != 0) return abbruch_mit(errno, ExecStufe::Ausfuehrung);
    if (::pipe(rohr_err) != 0) return abbruch_mit(errno, ExecStufe::Ausfuehrung);
    // Die Selbst-Pipe traegt FD_CLOEXEC: gelingt exec, schliesst der Kernel sie und der
    // Vater liest 0 Byte. Genau daran erkennt er, dass der Prozess wirklich lief.
    if (::pipe(rohr_exec) != 0) return abbruch_mit(errno, ExecStufe::Ausfuehrung);
    if (::fcntl(rohr_exec[1], F_SETFD, FD_CLOEXEC) != 0) return abbruch_mit(errno, ExecStufe::Ausfuehrung);

    // argv fuer execvp vorbereiten -- VOR dem fork, damit im Kind nichts allokiert wird.
    std::vector<char*> roh;
    roh.reserve(auftrag.argv.size() + 1);
    for (const std::string& s : auftrag.argv) { roh.push_back(const_cast<char*>(s.c_str())); }
    roh.push_back(nullptr);

    const pid_t kind = ::fork();
    if (kind < 0) return abbruch_mit(errno, ExecStufe::Ausfuehrung);

    if (kind == 0) {
        // ---- Kind ----------------------------------------------------------------
        ::close(rohr_out[0]);
        ::close(rohr_err[0]);
        ::close(rohr_exec[0]);

        ExecMeldung meldung;
        for (const std::string& name : auftrag.env_entfernen) { ::unsetenv(name.c_str()); }
        if (!auftrag.arbeitsverzeichnis.empty() && ::chdir(auftrag.arbeitsverzeichnis.c_str()) != 0) {
            meldung.stufe           = 1;
            meldung.fehler          = errno;
            const ssize_t ignoriert = ::write(rohr_exec[1], &meldung, sizeof(meldung));
            (void)ignoriert;
            ::_exit(127);
        }
        if (::dup2(rohr_out[1], STDOUT_FILENO) < 0 || ::dup2(rohr_err[1], STDERR_FILENO) < 0) {
            meldung.stufe           = 2;
            meldung.fehler          = errno;
            const ssize_t ignoriert = ::write(rohr_exec[1], &meldung, sizeof(meldung));
            (void)ignoriert;
            ::_exit(127);
        }
        ::close(rohr_out[1]);
        ::close(rohr_err[1]);

        ::execvp(roh[0], roh.data());

        // Nur erreichbar, wenn exec SCHEITERTE. Genau das ist die Nachricht.
        meldung.stufe           = 2;
        meldung.fehler          = errno;
        const ssize_t ignoriert = ::write(rohr_exec[1], &meldung, sizeof(meldung));
        (void)ignoriert;
        ::_exit(127);
    }

    // ---- Vater -------------------------------------------------------------------
    schliesse(rohr_out[1]);
    schliesse(rohr_err[1]);
    schliesse(rohr_exec[1]);

    std::string exec_rohdaten;
    Leser       leser[3] = {
        {rohr_out[0], &aus.ausgabe, true},
        {rohr_err[0], &aus.fehler, true},
        {rohr_exec[0], &exec_rohdaten, true},
    };

    char puffer[4096];
    while (leser[0].offen || leser[1].offen || leser[2].offen) {
        struct pollfd fds[3];
        int           anzahl       = 0;
        int           abbildung[3] = {-1, -1, -1};
        for (int i = 0; i < 3; ++i) {
            if (!leser[i].offen) continue;
            fds[anzahl].fd      = leser[i].fd;
            fds[anzahl].events  = POLLIN;
            fds[anzahl].revents = 0;
            abbildung[anzahl]   = i;
            ++anzahl;
        }
        const int bereit = ::poll(fds, static_cast<nfds_t>(anzahl), -1);
        if (bereit < 0) {
            if (errno == EINTR) continue;
            break; // poll selbst kaputt: die Schleife endet, waitpid urteilt gleich
        }
        for (int k = 0; k < anzahl; ++k) {
            if (fds[k].revents == 0) continue;
            const int     i       = abbildung[k];
            const ssize_t gelesen = ::read(leser[i].fd, puffer, sizeof(puffer));
            if (gelesen > 0) {
                leser[i].senke->append(puffer, static_cast<std::size_t>(gelesen));
            } else if (gelesen == 0 || (gelesen < 0 && errno != EINTR)) {
                schliesse(leser[i].fd);
                leser[i].offen = false;
            }
        }
    }
    for (int i = 0; i < 3; ++i) schliesse(leser[i].fd);

    int   zustand  = 0;
    pid_t gewartet = 0;
    do { gewartet = ::waitpid(kind, &zustand, 0); } while (gewartet < 0 && errno == EINTR);

    // Die Selbst-Pipe hat Vorrang: hat sie etwas geliefert, LIEF DER PROZESS NIE.
    // Sein Exit-Code (127) ist dann bedeutungslos und darf nirgends auftauchen.
    if (exec_rohdaten.size() >= sizeof(ExecMeldung)) {
        ExecMeldung meldung{};
        std::memcpy(&meldung, exec_rohdaten.data(), sizeof(meldung));
        aus.art   = ProzessArt::ExecFehlgeschlagen;
        aus.stufe = (meldung.stufe == 1) ? ExecStufe::Arbeitsverzeichnis : ExecStufe::Ausfuehrung;
        aus.code  = meldung.fehler;
        return aus;
    }

    if (gewartet < 0) {
        aus.art   = ProzessArt::ExecFehlgeschlagen;
        aus.stufe = ExecStufe::Ausfuehrung;
        aus.code  = errno;
        return aus;
    }
    if (WIFSIGNALED(zustand)) {
        aus.art  = ProzessArt::Signal;
        aus.code = WTERMSIG(zustand);
        return aus;
    }
    if (WIFEXITED(zustand)) {
        aus.art  = ProzessArt::Exit;
        aus.code = WEXITSTATUS(zustand);
        return aus;
    }
    aus.art   = ProzessArt::ExecFehlgeschlagen;
    aus.stufe = ExecStufe::Ausfuehrung;
    aus.code  = ECHILD;
    return aus;
}

ProzessAusgang fuehre_git_aus(const std::filesystem::path&    arbeitsverzeichnis,
                              const std::vector<std::string>& argumente) {
    ProzessAuftrag auftrag;
    auftrag.argv.reserve(argumente.size() + 1);
    auftrag.argv.push_back("git");
    for (const std::string& a : argumente) auftrag.argv.push_back(a);
    auftrag.arbeitsverzeichnis = arbeitsverzeichnis;
    // Dieselbe Liste, die die abgeloeste Shell-Probe entfernte (Zeile 142): ein von der
    // CI gesetztes GIT_DIR biegt sonst jedes Wegwerf-Fixture in ein fremdes Repo um.
    auftrag.env_entfernen = {"GIT_DIR",
                             "GIT_WORK_TREE",
                             "GIT_INDEX_FILE",
                             "GIT_OBJECT_DIRECTORY",
                             "GIT_ALTERNATE_OBJECT_DIRECTORIES",
                             "GIT_COMMON_DIR",
                             "GIT_CONFIG",
                             "GIT_CONFIG_GLOBAL"};
    return fuehre_aus(auftrag);
}

} // namespace comdare::ci_wachen
