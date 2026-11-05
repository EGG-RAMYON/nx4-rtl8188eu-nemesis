#!/bin/sh
set -eu
if [ "$#" -ne 2 ]; then
  echo "usage: $0 package.zip output-usb-bundle.zip" >&2
  exit 2
fi
PACKAGE=$(CDPATH= cd -- "$(dirname -- "$1")" && pwd)/$(basename -- "$1")
OUTPUT=$2
case "$OUTPUT" in /*) ;; *) OUTPUT=$(pwd)/$OUTPUT ;; esac
[ -f "$PACKAGE" ] || { echo "package ZIP not found" >&2; exit 3; }
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP/packages"
cp "$PACKAGE" "$TMP/packages/nx4.rtl8188eu.manual_v1.0.3.zip"
cat > "$TMP/NEMESIS.data" <<'DESC'
[nemesis]
version=1.0
type=install
path=packages/nx4.rtl8188eu.manual_v1.0.3.zip
DESC
mkdir -p "$(dirname -- "$OUTPUT")"
rm -f "$OUTPUT"
(cd "$TMP" && zip -X -q -r "$OUTPUT" NEMESIS.data packages)
echo "$OUTPUT"
