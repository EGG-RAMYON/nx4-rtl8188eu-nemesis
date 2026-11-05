#!/bin/sh
set -eu
if [ "$#" -ne 1 ]; then
  echo "usage: $0 package.zip" >&2
  exit 2
fi
ARCHIVE=$1
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
EXPECTED=0365d9267aa5c1d4c587646bbc354e047f51e9f78424dd4e54e2bbb78e342c02
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
unzip -tq "$ARCHIVE"
unzip -oq "$ARCHIVE" -d "$TMP"
for f in NEMESIS.data modules/r8188eu.ko svc/wifi-service.sh scripts/preinstall.sh scripts/postinstall.sh scripts/preuninstall.sh bin/enable.sh bin/restore.sh; do
  [ -f "$TMP/$f" ] || { echo "missing package file: $f" >&2; exit 3; }
done
grep -qx 'version=1.1' "$TMP/NEMESIS.data"
grep -qx 'id=nx4.rtl8188eu.manual' "$TMP/NEMESIS.data"
grep -qx 'package-version=1.0.3' "$TMP/NEMESIS.data"
ACTUAL=$(sha256sum "$TMP/modules/r8188eu.ko" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "module SHA-256 mismatch" >&2; exit 4; }
for f in "$TMP"/svc/*.sh "$TMP"/scripts/*.sh "$TMP"/bin/*.sh; do
  sh -n "$f"
  [ -x "$f" ] || { echo "script is not executable in archive: $f" >&2; exit 5; }
done
printf '%s\n' 'Package archive, metadata, required files, module digest, and shell syntax: PASS'
