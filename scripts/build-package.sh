#!/bin/sh
set -eu
if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/r8188eu.ko output.zip" >&2
  exit 2
fi
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
MODULE=$(CDPATH= cd -- "$(dirname -- "$1")" && pwd)/$(basename -- "$1")
OUTPUT=$2
case "$OUTPUT" in /*) ;; *) OUTPUT=$(pwd)/$OUTPUT ;; esac
EXPECTED=0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02
command -v zip >/dev/null 2>&1 || { echo "zip is required" >&2; exit 3; }
command -v sha256sum >/dev/null 2>&1 || { echo "sha256sum is required" >&2; exit 3; }
[ -f "$MODULE" ] || { echo "module not found: $MODULE" >&2; exit 4; }
ACTUAL=$(sha256sum "$MODULE" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "module SHA-256 mismatch" >&2; exit 5; }
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
cp -R "$ROOT/package/." "$TMP/"
mkdir -p "$TMP/modules"
cp "$MODULE" "$TMP/modules/r8188eu.ko"
mkdir -p "$(dirname -- "$OUTPUT")"
rm -f "$OUTPUT"
(cd "$TMP" && zip -X -q -r "$OUTPUT" NEMESIS.data modules svc scripts bin)
echo "$OUTPUT"
