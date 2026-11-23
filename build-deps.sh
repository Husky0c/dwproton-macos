#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
    printf 'Usage: sh build-deps.sh SOURCE_ARCHIVES OUTPUT_DIRECTORY\n' >&2
    exit 2
fi

archives=$(CDPATH= cd -- "$1" && pwd)
mkdir -p "$2"
out=$(CDPATH= cd -- "$2" && pwd)
mkdir "$out/sources"
sources="$out/sources"
tls="$out/tls"
freetype="$out/freetype"

export CC=/usr/bin/clang MACOSX_DEPLOYMENT_TARGET=14.0
export CFLAGS="-O2 -ffile-prefix-map=$sources=dependency-src"

extract() {
    tar -xf "$archives/$1" -C "$sources"
}

build() {
    package=$1
    shift
    (cd "$sources/$package" && ./configure "$@" && make -j"${JOBS:-8}" && make install)
}

extract freetype-2.15.0.tar.xz
build freetype-2.15.0 --prefix="$freetype" --without-brotli --without-bzip2 --without-harfbuzz --without-png

extract gmp-6.3.0.tar.xz
build gmp-6.3.0 --prefix="$tls" --build=x86_64-apple-darwin --with-pic --enable-shared --disable-static

export CPPFLAGS="-I$tls/include" LDFLAGS="-L$tls/lib"
export PKG_CONFIG_PATH="$tls/lib/pkgconfig"
export PKG_CONFIG=pkgconf

extract nettle-4.0.tar.gz
build nettle-4.0 --prefix="$tls" --enable-shared --disable-static

extract libtasn1-4.21.0.tar.gz
build libtasn1-4.21.0 --prefix="$tls" --enable-shared --disable-static --disable-doc

extract gnutls-3.8.14.tar.xz
build gnutls-3.8.14 --prefix="$tls" --enable-shared --disable-static --disable-cxx \
    --disable-tools --disable-tests --disable-doc --without-p11-kit --disable-libdane \
    --without-idn --without-brotli --without-zstd --disable-nls --with-included-unistring \
    --with-default-trust-store-file=/etc/ssl/cert.pem --with-system-priority-file=/etc/gnutls/config
