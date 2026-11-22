-- include subprojects
includes("lib/commonlibsse-ng")

-- set project constants
set_project("MantellaCorePlugins")
set_version("1.0.0")
set_license("MIT")
set_languages("c++23")
set_warnings("allextra")

-- add common rules
add_rules("mode.debug", "mode.releasedbg")
add_rules("plugin.vsxmake.autoupdate")

-- The original code calls the wide-character Windows functions through their plain names
-- (CreateProcess, GetModuleFileName, MoveFile...), and the old CMake template set these for it
add_defines("UNICODE", "_UNICODE", "NOMINMAX")

-- add packages
add_requires("cpr 1.14.2")
add_requires("nlohmann_json v3.12.0")

-- Talks to Mantella over HTTP (localhost) and keeps the dictionaries Mantella's scripts read and write
target("SKSE_HTTP")
    add_rules("commonlibsse-ng.plugin", {
        name = "SKSE_HTTP",
        author = "Leidtier",
        description = "Lets Papyrus send HTTP requests and read JSON replies"
    })

    add_packages("cpr", "nlohmann_json")

    add_files("SKSE_HTTP/plugin.cpp", "SKSE_HTTP/src/**.cpp")
    add_headerfiles("SKSE_HTTP/include/**.h")
    add_includedirs("SKSE_HTTP", "SKSE_HTTP/include")
    set_pcxxheader("SKSE_HTTP/PCH.h")

-- Starts Mantella.exe when the game has loaded, and lets the MCM restart it
target("MantellaLauncher")
    add_rules("commonlibsse-ng.plugin", {
        name = "MantellaLauncher",
        author = "art-from-the-machine",
        description = "Launches Mantella.exe with Skyrim"
    })

    -- The original code uses a few functions MSVC calls deprecated (wstring_convert, stricmp, _wcslwr)
    add_defines("_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING", "_CRT_SECURE_NO_WARNINGS", "_CRT_NONSTDC_NO_DEPRECATE")

    add_files("MantellaLauncher/plugin.cpp")
    add_includedirs("MantellaLauncher")
    set_pcxxheader("MantellaLauncher/PCH.h")

-- Shows the subtitles of what NPCs say in Mantella conversations
target("MantellaSubtitles")
    add_rules("commonlibsse-ng.plugin", {
        name = "MantellaSubtitles",
        author = "swwu",
        description = "Shows subtitles for Mantella conversations"
    })

    add_files("MantellaSubtitles/*.cpp")
    add_headerfiles("MantellaSubtitles/*.h")
    add_includedirs("MantellaSubtitles")
    set_pcxxheader("MantellaSubtitles/PCH.h")
