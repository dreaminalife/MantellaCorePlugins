# MantellaCorePlugins

The three SKSE plugins every [Mantella](https://github.com/art-from-the-machine/Mantella) install needs, rebuilt so they load on every Skyrim version: SE 1.5.97, AE 1.6.x and the newer 1.7.x.

| Plugin | What it does | Original source |
|---|---|---|
| `SKSE_HTTP.dll` | Lets Mantella's scripts talk to Mantella.exe | [Leidtier/SKSE_HTTP](https://github.com/Leidtier/SKSE_HTTP) @ `8da249b` |
| `MantellaLauncher.dll` | Starts Mantella.exe with the game, and lets the MCM restart it | [art-from-the-machine/Mantella-SKSE-Launcher](https://github.com/art-from-the-machine/Mantella-SKSE-Launcher) @ `a7fdb92` |
| `MantellaSubtitles.dll` | Shows subtitles for what NPCs say in a conversation | [swwu/Mantella-Subtitles-Plugin-NG](https://github.com/swwu/Mantella-Subtitles-Plugin-NG) @ `053a814` |

## Why this exists

Skyrim 1.7.99 and later ship the Address Library in a new file format. The DLLs Mantella shipped were built in 2022 and can't read it, so the game refuses to load them ("Unsupported address library format"). This repository builds the same code against CommonLibSSE-NG v13.1.0, which reads both the old and the new format. One DLL covers every game version.

The Papyrus functions are the same as before, so the existing `SKSE_HTTP.psc`, `MantellaLauncher.psc` and `MantellaSubtitles.psc` scripts work unchanged.

## What was changed

The first commit is the original code, copied unchanged. Everything after it is what was needed to build it with the newer CommonLib:

- **SKSE_HTTP:** `Setting::GetUInt()` is now called `GetUnsignedInteger()`.
- **MantellaSubtitles:** two log lines print `subtitle.c_str()`, because the new logger can't print a game string directly. `IsDebuggerPresent` comes from CommonLib's Windows functions, and `SKSE::Init` is told not to replace the plugin's own log file.
- **MantellaLauncher:** no code changes.

## Building

The DLLs are built by GitHub Actions on every push (`.github/workflows/build.yml`); download them from the run's Artifacts. To build locally you need VS 2022 with the C++ workload, CMake (for the HTTP library) and [xmake](https://xmake.io) 3.0+:

```bat
git clone --recurse-submodules <this repository>
xmake config --mode=releasedbg
xmake build SKSE_HTTP
xmake build MantellaLauncher
xmake build MantellaSubtitles
```

The output is in `build/windows/x64/releasedbg/`.

## License

Each plugin keeps its original MIT license (the `LICENSE` file in its folder). The built DLLs statically link [CommonLibSSE-NG](https://github.com/alandtse/CommonLibVR) (`lib/commonlibsse-ng`), which is GPL-3.0 with a modding exception, so the DLLs are distributed under those terms.
