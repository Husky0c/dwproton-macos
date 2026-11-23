# Build on Intel macOS

The release uses Wine commit `a45ed99f3b9898eaec1303458bf40d082a6565b7` from Dawn Winery. The corresponding source archive includes the upstream Wine tree, the Darwin patch, dependency source archives, and these scripts. [Upstream Wine tree](https://dawn.wine/dawn-winery/wine-dwproton/commit/a45ed99f3b9898eaec1303458bf40d082a6565b7)

Install the Xcode Command Line Tools, GNU Autoconf, M4, Bison 3, pkgconf and Python 3. Put them on `PATH`. The release was compiled with the `llvm-mingw-20261117-ucrt-macos-universal` toolchain. [LLVM-MinGW release](https://github.com/mstorsjo/llvm-mingw/releases/tag/20261117)

From the extracted corresponding source archive, with `LLVM_MINGW` set to the toolchain directory, run:

```sh
sh build-deps.sh dependencies "$PWD/out/deps"
sh build.sh wine-src "$LLVM_MINGW" "$PWD/out/deps/freetype" \
    "$PWD/out/deps/tls" "$PWD/out/wine-build"
```

`build.sh` applies the patch in the supplied Wine source tree. Use a fresh copy for each build. `JOBS` sets the compilation parallelism and defaults to eight. The installed Wine runtime is in `out/wine-build/stage/opt/dwproton-macos` and can be moved as a directory. When a Windows application requests Vulkan, Wine uses the installed 1401 NVIDIA Vulkan runtime.
