# Build on Intel macOS

This repository contains the Wine source tree and macOS changes. The upstream base is Dawn Winery Wine commit `a45ed99f3b9898eaec1303458bf40d082a6565b7`. [Upstream Wine commit](https://dawn.wine/dawn-winery/wine-dwproton/commit/a45ed99f3b9898eaec1303458bf40d082a6565b7)

Install the Xcode Command Line Tools, GNU Autoconf, M4, Bison 3, pkgconf and Python 3. Put them on `PATH`. The release was compiled with the `llvm-mingw-20261117-ucrt-macos-universal` toolchain. [LLVM-MinGW release](https://github.com/mstorsjo/llvm-mingw/releases/tag/20261117)

Clone the repository and run the following from its root. Set `LLVM_MINGW` to the toolchain directory and `DEPENDENCY_ARCHIVES` to the directory containing the five dependency archives. The corresponding source archive for the first preview includes those archives under `dependencies/`. [Dependency versions](THIRD_PARTY.md) · [Release source archive](https://github.com/Husky0c/dwproton-macos/releases/tag/v11.0-17-macos.1)

```sh
sh build-deps.sh "$DEPENDENCY_ARCHIVES" "$PWD/out/deps"
sh build.sh "$LLVM_MINGW" "$PWD/out/deps/freetype" "$PWD/out/deps/tls" "$PWD/out/wine-build"
```

`build.sh` generates the Wine configure script and builds the checked-out source in the output directory you supply. Use a new output directory for each build. `JOBS` sets the compilation parallelism and defaults to eight. The installed Wine runtime is in `out/wine-build/stage/opt/dwproton-macos` and can be moved as a directory. When a Windows application requests Vulkan, Wine uses the installed 1401 NVIDIA Vulkan runtime.
