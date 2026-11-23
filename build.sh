#!/bin/sh
set -eu

if [ "$#" -ne 5 ]; then
    printf 'Usage: sh build.sh WINE_SOURCE LLVM_MINGW FREETYPE_PREFIX TLS_PREFIX BUILD_DIRECTORY\n' >&2
    exit 2
fi

project=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source=$(CDPATH= cd -- "$1" && pwd)
mingw=$(CDPATH= cd -- "$2" && pwd)
freetype=$(CDPATH= cd -- "$3" && pwd)
tls=$(CDPATH= cd -- "$4" && pwd)
mkdir -p "$5"
build=$(CDPATH= cd -- "$5" && pwd)

if [ "$(uname -m)" != x86_64 ]; then
    printf 'This build targets an Intel Mac.\n' >&2
    exit 1
fi
if [ -e "$build/Makefile" ]; then
    printf 'Use a new build directory.\n' >&2
    exit 1
fi

git -C "$source" apply --check "$project/darwin.patch"
git -C "$source" apply "$project/darwin.patch"
(cd "$source" && ./autogen.sh)

export PATH="$tls/bin:$PATH:$mingw/bin"
export MACOSX_DEPLOYMENT_TARGET=14.0
export CC=/usr/bin/clang CXX=/usr/bin/clang++
export CFLAGS="-O2 -ffile-prefix-map=$source=wine-src -ffile-prefix-map=$build=wine-build"
export CXXFLAGS="$CFLAGS" CROSSCFLAGS="$CFLAGS"
export FREETYPE_CFLAGS="-I$freetype/include/freetype2" FREETYPE_LIBS="-L$freetype/lib -lfreetype"
export GNUTLS_CFLAGS="-I$tls/include" GNUTLS_LIBS="-L$tls/lib -lgnutls"
export GMP_CFLAGS="-I$tls/include" GMP_LIBS="-L$tls/lib -lgmp"
export ac_cv_lib_soname_freetype='@loader_path/../../libfreetype.6.dylib'
export ac_cv_lib_soname_gnutls='@loader_path/../../libgnutls.30.dylib'
export ac_cv_lib_soname_gmp='@loader_path/../../libgmp.10.dylib'
export ac_cv_lib_soname_vulkan=/Library/GPUBundles/nvmtl/libvulkan.1.dylib

cd "$build"
"$source/configure" --prefix=/opt/dwproton-macos --build=x86_64-apple-darwin \
    --enable-archs=i386,x86_64 --disable-tests --disable-amd_ags_x64 --disable-loader64 \
    --with-mingw="$mingw/bin/clang" --with-freetype --with-coreaudio --with-vulkan \
    --with-gnutls --without-opengl --without-wayland --without-x
make -j"${JOBS:-8}"
make -j"${JOBS:-8}" install DESTDIR="$build/stage"

runtime="$build/stage/opt/dwproton-macos"
cp "$freetype/lib/libfreetype.6.dylib" "$runtime/lib/"
tls_libraries='libgmp.10.dylib libgnutls.30.dylib libhogweed.7.dylib libnettle.9.dylib libtasn1.6.dylib'
for lib in $tls_libraries; do
    cp "$tls/lib/$lib" "$runtime/lib/"
    install_name_tool -id "@loader_path/$lib" "$runtime/lib/$lib"
    for dep in $tls_libraries; do
        install_name_tool -change "$tls/lib/$dep" "@loader_path/$dep" "$runtime/lib/$lib"
    done
done
install_name_tool -id '@loader_path/libfreetype.6.dylib' "$runtime/lib/libfreetype.6.dylib"
printf 'Runtime built at %s\n' "$runtime"
