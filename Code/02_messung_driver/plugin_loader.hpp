// SPDX-License-Identifier: Apache-2.0
// V38.C (2026-05-24) - Cross-Platform Plugin-Loader fuer dynamisch ladbare
// Permutations-Module (.dll / .so / .dylib).
//
// Pro Plugin: ein einziges Entry-Symbol `comdare_perm_descriptor()` das
// Pointer auf PermDescriptor liefert (id, version, axes, run-pointer).
//
// Cross-platform via #ifdef:
//   Windows: LoadLibraryA + GetProcAddress + FreeLibrary
//   Posix:   dlopen + dlsym + dlclose

#pragma once

#include <cstdint>
#include <filesystem>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

#if defined(_WIN32)
  #ifndef WIN32_LEAN_AND_MEAN
    #define WIN32_LEAN_AND_MEAN
  #endif
  #ifndef NOMINMAX
    #define NOMINMAX
  #endif
  #include <windows.h>
  using PluginHandle = HMODULE;
#else
  #include <dlfcn.h>
  using PluginHandle = void*;
#endif

namespace comdare::messung_driver {

// ABI-stabile Struktur, identisch zur Definition in den Wrappern
struct PermDescriptor {
    const char* id;
    const char* version;
    const char* axes;
    int (*run)(unsigned long n_ops, double* out_micros_per_op);
};

struct LoadedPlugin {
    PluginHandle handle {};
    PermDescriptor const* desc {nullptr};
    std::filesystem::path path;
};

inline PluginHandle plugin_open(std::filesystem::path const& p) {
#if defined(_WIN32)
    return ::LoadLibraryA(p.string().c_str());
#else
    return ::dlopen(p.c_str(), RTLD_NOW | RTLD_LOCAL);
#endif
}

inline void plugin_close(PluginHandle h) {
    if (!h) return;
#if defined(_WIN32)
    ::FreeLibrary(h);
#else
    ::dlclose(h);
#endif
}

inline void* plugin_sym(PluginHandle h, char const* name) {
#if defined(_WIN32)
    return reinterpret_cast<void*>(::GetProcAddress(h, name));
#else
    return ::dlsym(h, name);
#endif
}

inline LoadedPlugin load_perm_plugin(std::filesystem::path const& p) {
    LoadedPlugin lp;
    lp.path   = p;
    lp.handle = plugin_open(p);
    if (!lp.handle) {
        return lp;
    }
    using DescFn = const PermDescriptor* (*)();
    auto fn = reinterpret_cast<DescFn>(plugin_sym(lp.handle, "comdare_perm_descriptor"));
    if (!fn) {
        plugin_close(lp.handle);
        lp.handle = nullptr;
        return lp;
    }
    lp.desc = fn();
    return lp;
}

// Scannt rekursiv ein perm-Subsystem-Verzeichnis (cache_engine/ oder prt_art/)
// nach .dll/.so/.dylib-Dateien (alle Plugin-Dateien).
inline std::vector<std::filesystem::path> discover_plugin_paths(std::filesystem::path const& root) {
    std::vector<std::filesystem::path> out;
    if (!std::filesystem::exists(root)) {
        return out;
    }
    namespace fs = std::filesystem;
    for (auto& entry : fs::recursive_directory_iterator(root)) {
        if (!entry.is_regular_file()) continue;
        auto const& path = entry.path();
        auto ext = path.extension().string();
        // Windows: .dll  Linux: .so  macOS: .dylib
        if (ext == ".dll" || ext == ".so" || ext == ".dylib") {
            // Filter: nur Dateien die mit "perm_" anfangen
            auto name = path.stem().string();
            if (name.rfind("perm_", 0) == 0) {
                out.push_back(path);
            }
        }
    }
    return out;
}

// Hochlevel-API: laedt alle Plugins beider Wurzeln (cache_engine + prt_art).
// perm_root = ${BINARY_DIR}/perm
inline std::vector<LoadedPlugin> load_all_perm_plugins(std::filesystem::path const& perm_root) {
    std::vector<LoadedPlugin> out;
    auto ce_paths = discover_plugin_paths(perm_root / "cache_engine");
    auto pa_paths = discover_plugin_paths(perm_root / "prt_art");
    out.reserve(ce_paths.size() + pa_paths.size());
    for (auto& p : ce_paths) {
        auto lp = load_perm_plugin(p);
        if (lp.handle && lp.desc) {
            out.push_back(lp);
        } else {
            std::cerr << "[V38.C] WARN: konnte nicht laden: " << p.string() << "\n";
            if (lp.handle) plugin_close(lp.handle);
        }
    }
    for (auto& p : pa_paths) {
        auto lp = load_perm_plugin(p);
        if (lp.handle && lp.desc) {
            out.push_back(lp);
        } else {
            std::cerr << "[V38.C] WARN: konnte nicht laden: " << p.string() << "\n";
            if (lp.handle) plugin_close(lp.handle);
        }
    }
    return out;
}

inline void unload_all(std::vector<LoadedPlugin>& plugins) {
    for (auto& lp : plugins) {
        plugin_close(lp.handle);
        lp.handle = nullptr;
        lp.desc   = nullptr;
    }
    plugins.clear();
}

}  // namespace comdare::messung_driver
