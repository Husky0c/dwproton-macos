#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
    printf 'Usage: sh package-macos.sh WINE_RUNTIME DEPENDENCY_SOURCES OUTPUT_DIRECTORY\n' >&2
    exit 2
fi

source=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
runtime=$(CDPATH= cd -- "$1" && pwd -P)
dependencies=$(CDPATH= cd -- "$2" && pwd -P)
mkdir -p "$3"
output=$(CDPATH= cd -- "$3" && pwd -P)

if [ ! -x "$runtime/bin/wine" ] || [ ! -x "$runtime/bin/wineserver" ]; then
    printf 'Wine runtime is missing wine or wineserver in %s/bin\n' "$runtime" >&2
    exit 1
fi

version=$(cat "$source/MACOS_VERSION")
name="dwproton-x64-macos-$version.app"
if [ -e "$output/$name" ] || [ -L "$output/$name" ]; then
    printf 'Package already exists at %s\n' "$output/$name" >&2
    exit 1
fi

staging=$(mktemp -d "$output/.package-macos.XXXXXXXX")
trap 'rm -rf -- "$staging"' EXIT
trap 'exit 1' HUP INT TERM
contents="$staging/$name/Contents"
licenses="$contents/Resources/licenses"

mkdir -p "$licenses/Wine" "$licenses/FreeType" "$licenses/GMP" "$licenses/Nettle" \
    "$licenses/libtasn1" "$licenses/GnuTLS"
cp -Rp "$runtime" "$contents/Resources/wine"
cp "$source/AUTHORS" "$source/COPYING.LIB" "$source/LICENSE" "$licenses/Wine/"
cp "$source/THIRD_PARTY.md" "$licenses/"
(cd "$dependencies/freetype-2.15.0" && cp LICENSE.TXT docs/FTL.TXT docs/GPLv2.TXT "$licenses/FreeType/")
(cd "$dependencies/gmp-6.3.0" && cp COPYING COPYING.LESSERv3 COPYINGv2 COPYINGv3 "$licenses/GMP/")
(cd "$dependencies/nettle-4.0" && cp COPYING.LESSERv3 COPYINGv2 COPYINGv3 "$licenses/Nettle/")
(cd "$dependencies/libtasn1-4.21.0" && cp COPYING COPYING.LESSERv2 "$licenses/libtasn1/")
(cd "$dependencies/gnutls-3.8.14" && cp COPYING COPYING.LESSERv2 "$licenses/GnuTLS/")

cat > "$contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>io.github.Husky0c.dwproton-macos</string>
    <key>CFBundleName</key>
    <string>DWProton macOS x64</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$version</string>
    <key>CFBundleVersion</key>
    <string>$version</string>
</dict>
</plist>
EOF

plutil -lint "$contents/Info.plist" >/dev/null
mv "$staging/$name" "$output/"
printf 'Heroic package built at %s\n' "$output/$name"
